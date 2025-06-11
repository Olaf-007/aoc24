#let read_input() = {
  // Read the input file
  let raw_input = read("../inputs/day5.txt").trim()
  
  // Split into two sections by double newline
  let sections = raw_input.split("\n\n")
  let rules_section = sections.at(0).split("\n")
  let updates_section = sections.at(1).split("\n")
  
  // Parse rules into conditions dictionary
  let cond = (:)
  for rule_str in rules_section {
    let parts = rule_str.split("|")
    let before = int(parts.at(0))
    let after = int(parts.at(1))
    
    // Build reverse mapping: after -> set of pages that must come before it
    if str(after) in cond {
      cond.at(str(after)).push(before)
    } else {
      cond.insert(str(after), (before,))
    }
  }
  
  // Parse updates (rows of page numbers)
  let updates = ()
  for update_str in updates_section {
    let pages = ()
    for page_str in update_str.split(",") {
      pages.push(int(page_str))
    }
    updates.push(pages)
  }
  
  (cond: cond, updates: updates)
}

// Solves Part 1: Find correctly ordered updates and sum their middle page numbers
#let solve_part1(data) = {
  let cond = data.cond
  let updates = data.updates
  let sum = 0
  
  for update in updates {
    let correct = true
    let forbidden_pages = ()  // Pages that cannot appear anymore
    
    for page in update {
      // Check if this page is in the forbidden list
      if page in forbidden_pages {
        correct = false
        break
      }
      
      // Add pages that must come before this page to forbidden list
      if str(page) in cond {
        for forbidden_page in cond.at(str(page)) {
          forbidden_pages.push(forbidden_page)
        }
      }
    }
    
    if correct {
      let middle_index = int((update.len() - 1) / 2)
      sum += update.at(middle_index)
    }
  }
  
  sum
}

// Solves Part 2: Fix incorrectly ordered updates and sum their middle page numbers
#let solve_part2(data) = {
  let cond = data.cond
  let updates = data.updates
  let sum = 0
  
  // First, identify incorrect updates
  let incorrect_updates = ()
  
  for update in updates {
    let correct = true
    let forbidden_pages = ()
    
    for page in update {
      if page in forbidden_pages {
        correct = false
        break
      }
      
      if str(page) in cond {
        for forbidden_page in cond.at(str(page)) {
          forbidden_pages.push(forbidden_page)
        }
      }
    }
    
    if not correct {
      incorrect_updates.push(update)
    }
  }
  
  // Now fix each incorrect update
  for update in incorrect_updates {
    let fixed_update = update
    let i = 0
    
    // Keep reordering until the update is correct
    while i < fixed_update.len() - 1 {
      let current_page = fixed_update.at(i)
      let remaining_pages = ()
      
      // Get remaining pages after current position
      for j in range(i + 1, fixed_update.len()) {
        remaining_pages.push(fixed_update.at(j))
      }
      
      // Find intersection of pages that must come before current_page
      // and pages that appear after current_page
      let must_come_before = ()
      if str(current_page) in cond {
        must_come_before = cond.at(str(current_page))
      }
      
      let intersection = ()
      for page in remaining_pages {
        if page in must_come_before {
          intersection.push(page)
        }
      }
      
      if intersection.len() > 0 {
        // Find the rightmost position among conflicting pages
        let max_pos = -1
        for conflicting_page in intersection {
          for j in range(fixed_update.len()) {
            if fixed_update.at(j) == conflicting_page {
              if j > max_pos {
                max_pos = j
              }
            }
          }
        }
        
        // Move current page to position after the rightmost conflicting page
        let page_to_move = fixed_update.at(i)
        let new_update = ()
        
        // Copy elements before current position
        for j in range(i) {
          new_update.push(fixed_update.at(j))
        }
        
        // Copy elements from i+1 to max_pos (inclusive)
        for j in range(i + 1, max_pos + 1) {
          new_update.push(fixed_update.at(j))
        }
        
        // Insert the moved page
        new_update.push(page_to_move)
        
        // Copy remaining elements
        for j in range(max_pos + 1, fixed_update.len()) {
          new_update.push(fixed_update.at(j))
        }
        
        fixed_update = new_update
        i = 0  // Restart from beginning
      } else {
        i += 1
      }
    }
    
    // Add middle page number of fixed update
    let middle_index = int((fixed_update.len() - 1) / 2)
    sum += fixed_update.at(middle_index)
  }
  
  sum
}

// Main solving function for Day 5.
// This is called by `main.typ` to retrieve the final answers.
#let solve() = {
  let input_data = read_input()
  let part1_result = solve_part1(input_data)
  let part2_result = solve_part2(input_data)

  // Return the results in the required dictionary format.
  (
    part1: part1_result,
    part2: part2_result
  )
}