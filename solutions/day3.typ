#let read_input() = {
  // Read the input file
  let raw_input = read("../inputs/day3.txt").trim()
  raw_input // return the raw corrupted memory string
}

// Part 1: Find all valid mul(X,Y) instructions and sum their products
#let solve_part1(data) = {
  
  let total = 0
  
  // Use regex to find all valid mul(X,Y) patterns
  // Pattern: mul( followed by 1-3 digits, comma, 1-3 digits, closing )
  let mul_pattern = regex("mul\((\d{1,3}),(\d{1,3})\)")
  let matches = data.matches(mul_pattern)
  
  for match in matches {
    // Extract the two numbers from the capture groups
    let x = int(match.captures.at(0))
    let y = int(match.captures.at(1))
    total += x * y
  }
  
  total // return
}

// Part 2: Handle do() and don't() instructions along with mul(X,Y)
#let solve_part2(data) = {
  let total = 0
  let mul_enabled = true // mul instructions start enabled
  
  // Find all relevant instructions: mul(X,Y), do(), don't()
  let instruction_pattern = regex("mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")
  let matches = data.matches(instruction_pattern)
  
  for match in matches {
    let instruction = match.text
    
    if instruction == "do()" {
      mul_enabled = true
    } else if instruction == "don't()" {
      mul_enabled = false
    } else if instruction.starts-with("mul(") and mul_enabled {
      // Extract numbers from mul instruction
      let x = int(match.captures.at(0))
      let y = int(match.captures.at(1))
      total += x * y
    }
  }
  
  total // return
}

// Main solving function that returns results for both parts
#let solve() = {
  let input_data = read_input()
  let part1_result = solve_part1(input_data)
  let part2_result = solve_part2(input_data)
  
  // Return results with explanations
  (
    part1: part1_result,
    part2: part2_result,
  )
}

