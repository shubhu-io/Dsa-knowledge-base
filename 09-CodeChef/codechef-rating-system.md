# CodeChef Rating System

## Overview

CodeChef uses a star-based rating system that categorizes programmers from 1-star (beginner) to 7-stars (master). Your rating changes based on contest performance relative to other participants.

## Rating Tiers

### Star Ratings

| Stars | Rating Range | Title | Percentage |
|-------|--------------|-------|------------|
| 1 Star | 100-1000 | Beginner | ~35% |
| 2 Stars | 1000-1200 | Pupil | ~25% |
| 3 Stars | 1200-1400 | Specialist | ~20% |
| 4 Stars | 1400-1600 | Expert | ~12% |
| 5 Stars | 1600-1900 | Candidate Master | ~5% |
| 6 Stars | 1900-2200 | Master | ~2% |
| 7 Stars | 2200+ | Grandmaster | ~1% |

### Visual Representation

```
7 Stars [2200+]  Grandmaster
6 Stars [1900-2200] Master
5 Stars [1600-1900] Candidate Master
4 Stars [1400-1600] Expert
3 Stars [1200-1400] Specialist
2 Stars [1000-1200] Pupil
1 Star [100-1000]  Beginner
```

## How Rating Changes Work

### Factors Affecting Rating Change

1. **Contest Rating**: The rating of the contest determines weight
2. **Your Rank**: Where you finish relative to others
3. **Number of Participants**: More participants = more stable
4. **Your Current Rating**: Higher rated = harder to gain

### Rating Change Calculation

```
Rating Change = (Expected Rank - Actual Rank) x Factor
```

- **Better than expected**: Rating increases
- **Worse than expected**: Rating decreases
- **Magnitude depends on**: Contest difficulty and participant count

### Example Scenarios

**Scenario 1: Beginner in Long Challenge**
- Current rating: 900
- Solve 5/8 problems correctly
- Rank: 500/2000
- Result: +30 to +50 rating

**Scenario 2: 3-Star in Cook-Off**
- Current rating: 1300
- Solve 4/5 problems
- Rank: 100/1500
- Result: +20 to +40 rating

**Scenario 3: 5-Star in Cook-Off**
- Current rating: 1700
- Solve 3/5 problems
- Rank: 20/800
- Result: +15 to +30 rating

## Star Promotion Requirements

### Promotion Thresholds

| From | To | Minimum Rating | Typical Performance |
|------|-----|----------------|---------------------|
| 1 Star | 2 Stars | 1000 | Solve 60% of easy problems |
| 2 Stars | 3 Stars | 1200 | Solve 70% of medium problems |
| 3 Stars | 4 Stars | 1400 | Solve 75% of medium-hard problems |
| 4 Stars | 5 Stars | 1600 | Solve 80% of hard problems |
| 5 Stars | 6 Stars | 1900 | Consistent top 10% in contests |
| 6 Stars | 7 Stars | 2200 | Consistent top 1% in contests |

### Promotion Rules

- Promotion happens after each contest
- Must maintain rating for 2 consecutive contests
- Rating decay occurs after 6 months of inactivity
- Promotions are easier than demotions

### Demotion Thresholds

| From | To | Rating Threshold |
|------|-----|------------------|
| 2 Stars | 1 Star | Below 900 |
| 3 Stars | 2 Stars | Below 1100 |
| 4 Stars | 3 Stars | Below 1300 |
| 5 Stars | 4 Stars | Below 1500 |
| 6 Stars | 5 Stars | Below 1800 |
| 7 Stars | 6 Stars | Below 2100 |

## Rating Graph Analysis

### Reading Your Rating Graph

- **X-axis**: Time (by contest)
- **Y-axis**: Rating value
- **Color bands**: Show star tiers
- **Peaks**: Best performances
- **Valleys**: Worst performances

### Good Rating Patterns

**Steady Climb**
- Consistent improvement over time
- Small rating gains per contest
- Indicates solid learning

**Plateau followed by jump**
- Learning phase followed by breakthrough
- Common when mastering new concepts

**Recovery after drop**
- Shows resilience
- Indicates strong fundamentals

### Problematic Patterns

**Wild Swings**
- Inconsistent performance
- May need more practice at current level

**Long Plateaus**
- Stuck at current level
- Need to learn new techniques

**Sharp Decline**
- Possible burnout or skill gap
- May need to revisit fundamentals

## Long Challenge Specific

### Extended Contest Benefits

1. **More time to think**: 10 days allows deep thinking
2. **Learn new concepts**: Can research and learn
3. **Partial scoring**: Get points for partial solutions
4. **Less pressure**: More relaxed than timed contests

### Strategy for Long Challenge

**Week 1 (Days 1-3)**
- Read all problems
- Solve easy problems (200-400 rated)
- Start medium problems

**Week 2 (Days 4-7)**
- Continue medium problems
- Start hard problems
- Optimize existing solutions

**Final Days (Days 8-10)**
- Focus on remaining problems
- Optimize for partial scores
- Review and finalize

## Cook-Off Specific

### Timed Contest Strategy

**First 15 minutes**
- Read all problems
- Identify easiest and hardest
- Plan your approach

**Middle 90 minutes**
- Solve problems in order of confidence
- Don't get stuck on one problem
- Skip and return if needed

**Final 30 minutes**
- Review submissions
- Check for edge cases
- Submit remaining solutions

## Improving Your Rating

### Stage 1: Beginner to 2-Star (0-1000)
- Master basic programming concepts
- Solve 50+ 1-star problems
- Learn simple math operations
- Practice array and string manipulation

### Stage 2: 2-Star to 3-Star (1000-1200)
- Learn sorting algorithms
- Practice binary search
- Understand greedy algorithms
- Solve 50+ 2-star problems

### Stage 3: 3-Star to 4-Star (1200-1400)
- Master basic dynamic programming
- Learn graph traversal (BFS/DFS)
- Practice data structures
- Solve 50+ 3-star problems

### Stage 4: 4-Star to 5-Star (1400-1600)
- Advanced DP techniques
- Advanced graph algorithms
- Segment trees and BIT
- Solve 50+ 4-star problems

### Stage 5: 5-Star to 6-Star (1600-1900)
- Complex algorithms
- Advanced data structures
- Mathematical problem solving
- Consistent contest participation

### Stage 6: 6-Star to 7-Star (1900+)
- Elite algorithmic skills
- Research-level problems
- Innovation in approaches
- Top contest performance

## Rating Protection

### How to Avoid Rating Drops

1. **Participate regularly**: At least 1-2 contests per month
2. **Practice consistently**: Daily problem solving
3. **Stay calm during contests**: Don't panic
4. **Don't tilt**: Take breaks after bad performances
5. **Focus on learning**: Not just rating

### After a Bad Contest

- Analyze what went wrong
- Identify weak areas
- Practice those specific topics
- Don't rush to next contest
- Remember: rating recovers with consistent practice
