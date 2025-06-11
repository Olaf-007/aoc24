#let read_input() = {
  // Read the input file
  let raw_input = read("../inputs/day6.txt").trim().split("\n")
  raw_input // return the grid as array of strings
}

// Helper function to get character at position
#let get_char(grid, pos) = {
  let x = pos.at(0)
  let y = pos.at(1)
  if x < 0 or x >= grid.len() or y < 0 or y >= grid.at(0).len() {
    return none
  }
  grid.at(x).at(y)
}

// Helper function to check if position is inside grid
#let is_inside(grid, pos) = {
  let x = pos.at(0)
  let y = pos.at(1)
  x >= 0 and x < grid.len() and y >= 0 and y < grid.at(0).len()
}

// Helper function to add two positions
#let pos_add(pos1, pos2) = {
  (pos1.at(0) + pos2.at(0), pos1.at(1) + pos2.at(1))
}

// Helper function to turn right 90 degrees
#let turn_right(dir) = {
  if dir == (-1, 0) { (0, 1) }   // up -> right
  else if dir == (0, 1) { (1, 0) }    // right -> down  
  else if dir == (1, 0) { (0, -1) }   // down -> left
  else if dir == (0, -1) { (-1, 0) }  // left -> up
  else { dir }
}

// Find guard's starting position
#let find_guard_start(grid) = {
  for x in range(grid.len()) {
    for y in range(grid.at(x).len()) {
      if grid.at(x).at(y) == "^" {
        return (x, y)
      }
    }
  }
  (0, 0) // fallback
}

// Solves Part 1: Count distinct positions visited by guard
#let solve_part1(grid) = {
  let start_pos = find_guard_start(grid)
  let pos = start_pos
  let dir = (-1, 0) // facing up initially
  
  let visited = (pos,) // track visited positions
  
  while true {
    let next_pos = pos_add(pos, dir)
    
    // Check if next position is outside the grid
    if not is_inside(grid, next_pos) {
      break
    }
    
    // Check if there's an obstacle ahead
    if get_char(grid, next_pos) == "#" {
      dir = turn_right(dir)
    } else {
      pos = next_pos
      // Add to visited if not already there
      let already_visited = false
      for v in visited {
        if v.at(0) == pos.at(0) and v.at(1) == pos.at(1) {
          already_visited = true
          break
        }
      }
      if not already_visited {
        visited.push(pos)
      }
    }
  }
  
  visited.len()
}

// Helper function to check if position is in array
#let pos_in_array(pos, arr) = {
  for p in arr {
    if p.at(0) == pos.at(0) and p.at(1) == pos.at(1) {
      return true
    }
  }
  false
}

// Helper function to detect loop by checking if we've been in same state before
#let detect_loop(states, current_pos, current_dir) = {
  for state in states {
    if state.pos.at(0) == current_pos.at(0) and state.pos.at(1) == current_pos.at(1) and state.dir.at(0) == current_dir.at(0) and state.dir.at(1) == current_dir.at(1) {
      return true
    }
  }
  false
}

// Simulate guard movement with an additional obstacle
#let simulate_with_obstacle(grid, obstacle_pos, start_pos) = {
  let pos = start_pos
  let dir = (-1, 0)
  let states = () // track (position, direction) pairs
  
  while true {
    // Check for loop
    if detect_loop(states, pos, dir) {
      return true // loop detected
    }
    
    states.push((pos: pos, dir: dir))
    
    let next_pos = pos_add(pos, dir)
    
    // Check if next position is outside the grid
    if not is_inside(grid, next_pos) {
      return false // guard exits, no loop
    }
    
    // Check if there's an obstacle ahead (including our new obstacle)
    let is_obstacle = get_char(grid, next_pos) == "#" or (next_pos.at(0) == obstacle_pos.at(0) and next_pos.at(1) == obstacle_pos.at(1))
    
    if is_obstacle {
      dir = turn_right(dir)
    } else {
      pos = next_pos
    }
    
    // Safety check to prevent infinite loops in case of bug
    if states.len() > 10000 {
      return true // assume loop if taking too long
    }
  }
}

// Solves Part 2: Count positions where placing obstacle creates loop
#let solve_part2(grid) = {
  let start_pos = find_guard_start(grid)
  
  // First, get all positions the guard visits in normal patrol
  let pos = start_pos
  let dir = (-1, 0)
  let patrol_path = (pos,)
  
  while true {
    let next_pos = pos_add(pos, dir)
    
    if not is_inside(grid, next_pos) {
      break
    }
    
    if get_char(grid, next_pos) == "#" {
      dir = turn_right(dir)
    } else {
      pos = next_pos
      if not pos_in_array(pos, patrol_path) {
        patrol_path.push(pos)
      }
    }
  }
  
  // Try placing obstacle at each position on patrol path (except start)
  let loop_positions = 0
  
  for test_pos in patrol_path {
    // Skip if it's the starting position
    if test_pos.at(0) == start_pos.at(0) and test_pos.at(1) == start_pos.at(1) {
      continue
    }
    
    // Skip if there's already an obstacle there
    if get_char(grid, test_pos) == "#" {
      continue
    }
    
    // Test if placing obstacle here creates a loop
    if simulate_with_obstacle(grid, test_pos, start_pos) {
      loop_positions += 1
    }
  }
  
  loop_positions
}

// Main solving function for Day 6.
// This is called by `main.typ` to retrieve the final answers.
#let solve() = {
  let input_data = read_input()
  let part1_result = solve_part1(input_data)
  // let part2_result = solve_part2(input_data)

  // Return the results in the required dictionary format.
  (
    part1: part1_result,
    // part2: part2_result,
  )
}

#solve()