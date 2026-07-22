# Codeforces Rating System

## Overview

Codeforces uses an Elo-based rating system to rank competitive programmers. Your rating changes after each contest based on your performance relative to other participants.

## Rating Formula

### Basic Concept
- Rating is calculated using expected performance vs actual performance
- You gain rating by performing better than expected
- You lose rating by performing worse than expected
- The amount gained/lost depends on the contest's rating distribution

### Rating Change Calculation
```
Actual Rating Change = Sum of (Expected vs Actual performance)
```

- If you rank higher than expected: **+rating**
- If you rank lower than expected: **-rating**
- Maximum change per contest: **~100 points** (varies by rank)

## Rating Tiers

### Official Tiers

| Rating | Title | Badge Color | Percentage |
|--------|-------|-------------|------------|
| 0 - 1199 | Newbie | Gray | ~40% |
| 1200 - 1399 | Pupil | Green | ~25% |
| 1400 - 1599 | Specialist | Cyan | ~15% |
| 1600 - 1899 | Expert | Blue | ~12% |
| 1900 - 2099 | Candidate Master | Violet | ~5% |
| 2100 - 2299 | Master | Orange | ~2% |
| 2300 - 2399 | International Master | Orange | ~0.8% |
| 2400 - 2599 | Grandmaster | Red | ~0.3% |
| 2600 - 2899 | International Grandmaster | Red | ~0.09% |
| 2900+ | Legendary Grandmaster | Red + Name | ~0.01% |

### Title Colors in Practice

| Color | Titles | Skill Level |
|-------|--------|-------------|
| Gray | Newbie | Learning basics |
| Green | Pupil | Solid fundamentals |
| Cyan | Specialist | Good problem-solving |
| Blue | Expert | Strong competitive skills |
| Violet | CM | Advanced techniques |
| Orange | Master | Expert-level abilities |
| Red | GM/IGM/LGM | Elite programmers |

## How Rating Changes Work

### Factors Affecting Rating Change

1. **Your rating vs contest rating**
   - If you're lower rated than contest average: more to gain, less to lose
   - If you're higher rated than contest average: less to gain, more to lose

2. **Number of participants**
   - More participants = more stable rating changes
   - Fewer participants = more volatile changes

3. **Your rank in contest**
   - Top 10% = significant rating gain
   - Middle 50% = moderate change
   - Bottom 40% = rating loss

### Example Scenarios

**Scenario 1: Pupil in Div. 2**
- Rating: 1350
- Contest avg rating: 1400
- Rank: 150/2000
- Result: +25 to +40 rating

**Scenario 2: Expert in Div. 1**
- Rating: 1700
- Contest avg rating: 1900
- Rank: 50/800
- Result: +30 to +50 rating

**Scenario 3: Master in Div. 1**
- Rating: 2150
- Contest avg rating: 2200
- Rank: 20/300
- Result: +15 to +30 rating

## Rating Graph Analysis

### Reading Your Rating Graph

- **X-axis**: Time (by contest)
- **Y-axis**: Rating value
- **Color bands**: Show title tiers
- **Peaks**: Your highest performance
- **Valleys**: Your lowest performance

### Good Rating Graph Patterns
- **Steady climb**: Consistent improvement
- **Small fluctuations**: Stable performance
- **Recovery after drops**: Resilience

### Problematic Patterns
- **Wild swings**: Inconsistent preparation
- **Long plateaus**: Need to learn new techniques
- **Sharp declines**: May need to revisit fundamentals

## Rating Milestones

### Common Goals

| Milestone | Meaning | Typical Time |
|-----------|---------|--------------|
| Pupil (1200) | First real achievement | 1-3 months |
| Specialist (1400) | Good fundamentals | 3-6 months |
| Expert (1600) | Strong problem solver | 6-12 months |
| CM (1900) | Competitive programmer | 1-2 years |
| Master (2100) | Advanced techniques | 2-4 years |
| GM (2400) | Elite level | 4+ years |

### What Each Title Indicates

**Pupil (Green)**
- Understands basic data structures
- Can solve simple problems
- Knows time complexity basics

**Specialist (Cyan)**
- Solid with common algorithms
- Can solve medium problems
- Understands greedy and DP basics

**Expert (Blue)**
- Strong algorithmic thinking
- Can solve hard problems
- Knows advanced techniques

**Candidate Master (Violet)**
- Excellent problem-solving
- Strong in multiple domains
- Can handle contest pressure

**Master+ (Orange/Red)**
- Expert-level algorithmic skills
- Can solve most competitive problems
- Strong mathematical thinking

## Improving Your Rating

### Stage 1: Newbie → Pupil (0-1200)
- Learn basic sorting algorithms
- Master simple greedy problems
- Practice basic math problems
- Solve 100+ problems rated 800-1000

### Stage 2: Pupil → Specialist (1200-1400)
- Learn binary search thoroughly
- Practice string manipulation
- Understand basic graph traversal (BFS/DFS)
- Solve 100+ problems rated 1000-1400

### Stage 3: Specialist → Expert (1400-1600)
- Master dynamic programming basics
- Learn advanced graph algorithms
- Practice segment trees and BIT
- Solve 100+ problems rated 1200-1600

### Stage 4: Expert → CM (1600-1900)
- Advanced DP techniques
- Heavy-light decomposition
- Advanced data structures
- Solve 100+ problems rated 1400-1900

### Stage 5: CM → Master (1900-2100)
- Advanced algorithms (flows, matching)
- Complex mathematical proofs
- Optimization techniques
- Solve problems rated 1600-2100+

## Rating Protection

### How to Avoid Rating Drops
1. **Don't skip contests** you're prepared for
2. **Practice regularly** between contests
3. **Stay calm** during contests
4. **Don't tilt** after a bad performance
5. **Focus on learning**, not just rating

### After a Bad Contest
- Take a break if needed
- Review what went wrong
- Practice weak areas
- Don't rush to next contest for revenge
- Remember: rating will recover with consistent practice
