# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# Property-based invariant tests for TradeUnionist.jl

using Test
using TradeUnionist

@testset "Property-Based Tests" begin

    @testset "Invariant: calc_density is in [0, 100]" begin
        for _ in 1:50
            total = rand(1:1000)
            members = rand(0:total)
            d = calc_density(members, total)
            @test 0.0 <= d <= 100.0
        end
    end

    @testset "Invariant: calc_coverage is in [0, 100]" begin
        for _ in 1:50
            total = rand(1:1000)
            covered = rand(0:total)
            @test 0.0 <= calc_coverage(covered, total) <= 100.0
        end
    end

    @testset "Invariant: cost_proposal scales linearly with headcount" begin
        for _ in 1:50
            cost_per = rand(1.0:1.0:500.0)
            h1 = rand(1:200)
            h2 = rand(1:200)
            bp = BargainingProposal(:p, :c, "Raise", cost_per, :draft)
            @test cost_proposal(bp, h1 + h2) ≈ cost_proposal(bp, h1) + cost_proposal(bp, h2)
        end
    end

    @testset "Invariant: wage_gini_coefficient is in [0, 1)" begin
        for _ in 1:50
            n = rand(2:20)
            wages = rand(10_000.0:1.0:200_000.0, n)
            g = wage_gini_coefficient(wages)
            @test 0.0 <= g < 1.0
        end
    end

    @testset "Invariant: open_grievance always starts at :intake" begin
        for _ in 1:50
            member = Symbol("m$(rand(1:9999))")
            evidence = "Issue $(rand(1:9999))"
            gc = open_grievance(member, evidence)
            @test gc.status == :intake
        end
    end

end
