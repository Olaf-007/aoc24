#let read_input() = {
  // Read the input file // Has to be changed per riddle.
  let raw_input = read("../inputs/day1.txt").trim()
  
  // Parse the input into pairs of numbers
  let lines = raw_input.split("\n")
  let pairs = ()
  
  for line in lines {
    if line.trim() != "" {
      let parts = line.split(regex("\\s+"))
      if parts.len() >= 2 {
        let left = int(parts.at(0))
        let right = int(parts.at(1))
        pairs.push((left, right))
      }
    }
  }
  
  pairs // return
}

// Part 1: Calculate total distance between sorted lists
#let solve_part1(data) = {
  // Extract left and right lists
  let left_list = data.map(pair => pair.at(0))
  let right_list = data.map(pair => pair.at(1))
  
  // Sort both lists
  let sorted_left = left_list.sorted()
  let sorted_right = right_list.sorted()
  
  // Calculate total distance
  let total_distance = 0
  for i in range(sorted_left.len()) {
    total_distance += calc.abs(sorted_left.at(i) - sorted_right.at(i))
  }
  
  total_distance // return
}

// Part 2: Calculate similarity score
#let solve_part2(data) = {
  // Extract left and right lists
  let left_list = data.map(pair => pair.at(0))
  let right_list = data.map(pair => pair.at(1))
  
  // Count occurrences of each number in the right list
  let right_counts = (:)
  for num in right_list {
    let key = str(num)
    if key in right_counts {
      right_counts.at(key) += 1
    } else {
      right_counts.insert(key, 1)
    }
  }
  
  // Calculate similarity score
  let similarity_score = 0
  for num in left_list {
    let key = str(num)
    let count = if key in right_counts { right_counts.at(key) } else { 0 }
    similarity_score += num * count
  }
  
  similarity_score
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