#let read_input() = {
  // Read the input file for day 2
  let raw_input = read("../inputs/day2.txt").trim()
  
  // Parse the input into reports (lists of levels)
  let lines = raw_input.split("\n")
  let reports = ()
  
  for line in lines {
    if line.trim() != "" {
      let parts = line.split(regex("\\s+"))
      let levels = ()
      for part in parts {
        if part.trim() != "" {
          levels.push(int(part))
        }
      }
      if levels.len() > 0 {
        reports.push(levels)
      }
    }
  }
  
  reports // return
}

// Check if a report is safe according to the rules
#let is_safe_report(levels) = {
  if levels.len() < 2 {
    return true
  }
  
  let is_increasing = none
  
  for i in range(levels.len() - 1) {
    let current = levels.at(i)
    let next = levels.at(i + 1)
    let diff = next - current
    
    // Check if difference is within valid range (1-3)
    if calc.abs(diff) < 1 or calc.abs(diff) > 3 {
      return false
    }
    
    // Determine if sequence is increasing or decreasing
    if is_increasing == none {
      is_increasing = diff > 0
    } else {
      // Check if direction is consistent
      if (diff > 0) != is_increasing {
        return false
      }
    }
  }
  
  true
}

// Check if a report can be made safe by removing one level
#let can_be_safe_with_dampener(levels) = {
  // First check if it's already safe
  if is_safe_report(levels) {
    return true
  }
  
  // Try removing each level one by one
  for i in range(levels.len()) {
    let modified_levels = ()
    for j in range(levels.len()) {
      if j != i {
        modified_levels.push(levels.at(j))
      }
    }
    
    if is_safe_report(modified_levels) {
      return true
    }
  }
  
  false
}

// Part 1: Count safe reports
#let solve_part1(data) = {
  let safe_count = 0
  
  for report in data {
    if is_safe_report(report) {
      safe_count += 1
    }
  }
  
  safe_count // return
}

// Part 2: Count safe reports with Problem Dampener
#let solve_part2(data) = {
  let safe_count = 0
  
  for report in data {
    if can_be_safe_with_dampener(report) {
      safe_count += 1
    }
  }
  
  safe_count // return
}

// Main solving function that returns results for both parts
#let solve() = {
  let input_data = read_input()
  let part1_result = solve_part1(input_data)
  let part2_result = solve_part2(input_data)
  
  // Return results
  (
    part1: part1_result,
    part2: part2_result,
  )
}