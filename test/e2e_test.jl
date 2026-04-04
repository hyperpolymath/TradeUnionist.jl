# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# E2E pipeline tests for TradeUnionist.jl

using Test
using TradeUnionist
using Dates
using DataFrames

@testset "E2E Pipeline Tests" begin

    @testset "Full organising pipeline" begin
        # Register site → upsert members → log conversations → open grievances
        site = register_worksite("Hyperpolymath Corp", "Manchester", "Engineering", 300)
        @test site isa Worksite

        alice = upsert_member(site.id, :alice, :member, :steward)
        bob   = upsert_member(site.id, :bob,   :member, :organizer)

        conv_a = log_conversation(:alice, ["pay", "safety"], 0.75, "Follow up in 2 weeks")
        conv_b = log_conversation(:bob,   ["workload"],      0.4,  "Escalate to branch")

        @test conv_a.sentiment == 0.75
        @test conv_b.sentiment == 0.4

        gc = open_grievance(:alice, "Unsafe equipment on shop floor")
        @test gc.status == :intake
        update_grievance_status(gc, :step1)
        @test gc.status == :step1
        update_grievance_status(gc, :resolved)
        @test gc.status == :resolved
    end

    @testset "Bargaining cost pipeline" begin
        clause = ContractClause(:cl_e2e, "Living Wage", "£12/hr", "£15/hr", :high)
        df = compare_clauses(clause)
        @test nrow(df) == 1
        @test df.Proposed[1] == "£15/hr"

        bp = BargainingProposal(:bp_e2e, :cl_e2e, "Living Wage Increase", 3.0, :draft)
        total = cost_proposal(bp, 300)
        @test total == 900.0
    end

    @testset "Events pipeline" begin
        t = DateTime(2026, 5, 1, 10, 0, 0)
        evt = create_event_template(StrikeVote(), "Authorization Vote", t)
        @test evt isa UnionEvent
        @test evt.type isa StrikeVote
        @test evt.date == t
    end

    @testset "Error handling: calc_density with zero eligible" begin
        @test calc_density(0, 0) == 0.0
        @test calc_leadership_ratio(0, 0) == 0.0
        @test calc_coverage(0, 0) == 0.0
    end

end
