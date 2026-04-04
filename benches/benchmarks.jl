# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# BenchmarkTools benchmarks for TradeUnionist.jl

using BenchmarkTools
using TradeUnionist
using Dates

const SUITE = BenchmarkGroup()

SUITE["organizing"] = BenchmarkGroup()

SUITE["organizing"]["register_worksite"] = @benchmarkable register_worksite("Acme", "London", "Eng", 100)

SUITE["organizing"]["upsert_member"] = @benchmarkable upsert_member(:site1, :alice, :member, :steward)

SUITE["organizing"]["log_conversation"] = @benchmarkable log_conversation(:alice, ["pay", "safety"], 0.8, "Follow up")

SUITE["grievances"] = BenchmarkGroup()

SUITE["grievances"]["open_grievance"] = @benchmarkable open_grievance(:alice, "Safety issue")

SUITE["grievances"]["open_and_update"] = @benchmarkable begin
    gc = open_grievance(:bob, "Scheduling issue")
    update_grievance_status(gc, :step1)
    update_grievance_status(gc, :resolved)
end

SUITE["bargaining"] = BenchmarkGroup()

SUITE["bargaining"]["compare_clauses"] = let
    clause = ContractClause(:cl1, "Wages", "£12/hr", "£15/hr", :high)
    @benchmarkable compare_clauses($clause)
end

SUITE["bargaining"]["cost_proposal_1000"] = let
    bp = BargainingProposal(:bp1, :cl1, "Raise", 5.0, :draft)
    @benchmarkable cost_proposal($bp, 1000)
end

SUITE["metrics"] = BenchmarkGroup()

SUITE["metrics"]["calc_density"] = @benchmarkable calc_density(65, 100)

SUITE["metrics"]["wage_gini_100"] = let
    wages = rand(20_000.0:1.0:100_000.0, 100)
    @benchmarkable wage_gini_coefficient($wages)
end

SUITE["events"] = BenchmarkGroup()

SUITE["events"]["create_event_template"] = let
    t = DateTime(2026, 5, 1, 10, 0)
    @benchmarkable create_event_template(Rally(), "May Day", $t)
end

if abspath(PROGRAM_FILE) == @__FILE__
    tune!(SUITE)
    results = run(SUITE, verbose=true)
    BenchmarkTools.save("benchmarks_results.json", results)
end
