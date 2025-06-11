#let read_input() = {
  // Read the input file
  let raw_input = read("../inputs/day4.txt").trim().split("\n")
  raw_input // return the raw corrupted memory string
}


#let vec_add(a,b) = {
  let c = ()
  for i in range(a.len()) {
    c.push(a.at(i)+b.at(i))
  }
  c
}

#let vec_mul(s,v) = {
  let c = ()
  for i in range(v.len()) {
    c.push(s*v.at(i))
  }
  c
}


// Solves Part 1: Counts all occurrences of "XMAS" in any direction.
#let solve_part1(data) = {
  let count_xmas = 0
  
  for x in range(data.len()) { 
    for y in range(data.at(x).len()) {
      if data.at(x).at(y) == "X" {
        for d in ((1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(1,-1),(-1,1),) {
          let xmas_complete = true

          for i in ((1,"M"),(2,"A"),(3,"S")) {
            let pos = vec_add( (x,y) , vec_mul(i.at(0),d) )

            if pos.at(0) < 0 or pos.at(1) < 0 or pos.at(0) >= data.len() or pos.at(1) >= data.at(x).len() or data.at(pos.at(0)).at(pos.at(1)) != i.at(1) {
              xmas_complete = false
            }
            
          }

          if xmas_complete == true {
            count_xmas = count_xmas + 1
          }
        }
      }
    }
  }
  count_xmas
}

// Solves Part 2: Counts all "X-MAS" patterns.
#let solve_part2(data) = {
  let count_xmas = 0
  
  for x in range(data.len()) { 
    for y in range(data.at(x).len()) {
      if data.at(x).at(y) == "A" {
        let xmas_complete = true
        let pos1 = vec_add( (x,y) , (-1,-1) )
        let pos1o = vec_add( (x,y) , (1,1) )
        let pos2 = vec_add( (x,y) , (1,-1) )
        let pos2o = vec_add( (x,y) , (-1,1) )

        // Check if any of these positions is out of bounds: 
        for pos in (pos1,pos1o,pos2,pos2o) {
          if pos.at(0) < 0 or pos.at(1) < 0 or pos.at(0) >= data.len() or pos.at(1) >= data.at(pos.at(0)).len() { 
              xmas_complete = false
          }
        }

        let get_letter(pos) = {
          data.at(pos.at(0)).at(pos.at(1))
        }

        // Continue only if not out of bounds
        if xmas_complete == true {
          if ((get_letter(pos1) == "S" and get_letter(pos1o) == "M") == true or (get_letter(pos1) == "M" and get_letter(pos1o) == "S") == true) == true and ((get_letter(pos2) == "S" and get_letter(pos2o) == "M") == true or (get_letter(pos2) == "M" and get_letter(pos2o) == "S") == true) == true {
            xmas_complete = true
          } else { xmas_complete = false }
        }

        if xmas_complete == true {
          count_xmas = count_xmas + 1
        }
      }
    }
  }
        
  count_xmas
}

// Main solving function for Day 4.
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
