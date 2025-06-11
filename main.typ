// It is not (really) possible to check for the existence of a file yet, so: 
#let days_completed = 6   // This must be manually changed //
#let days_to_exclude = () // Skip days (if you want to exclude some) //

// In this loop all the solution code is actually performed, so it could take a while.
#let results = (:)
#for i in range(1,days_completed+1) {
  let skip = false
  for day in days_to_exclude {
    if day == i {skip = true}
  }
  if not skip {
    import "./solutions/day" + str(i) + ".typ" : solve
    results.insert(str(i),solve())
  }
}

#set heading(numbering: "1.")
#set text(size: 1.3em)

// Main title
#align(center)[
  #text(size: 1.5em, weight: "bold")[
    #emoji.santa.woman Advent of Code 2024 in Typst Summary #emoji.tree.xmas
  ]
  #v(0.5cm)
  #text(size: 1.4em)[
    Complete Results Table
  ]
]

#let tablecells = ()
#for i in range(1,26) {
  for j in range(3) {
    if j == 0 {tablecells.push([#i])}
    else {
      if str(i) in results {
        if "part" + str(j) in results.at(str(i)) {
            tablecells.push(table.cell(
              fill: gradient.linear(rgb("#f8e18c"), rgb("#dbb564"),rgb("f8e18c"), angle: 135deg).repeat(3),
              [#results.at(str(i)).at("part"+str(j))]
            ))
        } else {
          tablecells.push([TBD])  
        }
      } else {
        tablecells.push([TBD])
      }
    }
  }
}


// Create the main results table
#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.8pt,
  align: center,
  fill: (x, y) => if y == 0 { rgb("e8f4f8") } else {  },
  table.header(
    [*Day*], 
    [*Part 1*], 
    [*Part 2*]
  ),
  ..tablecells,
  
  // Day 1 results
  //[#results.at(0).part1 #emoji.star], 
  //[#results.at(0).part2],
)





/*


#v(1cm)

// Summary statistics
#let completed_days = results.len()
#let total_stars = results.fold(0, (acc, day) => {
  acc + (if day.part1 != "TBD" { 1 } else { 0 }) + (if day.part2 != "TBD" { 1 } else { 0 })
})

#align(center)[
  #rect(
    fill: rgb("f0f9ff"),
    stroke: 2pt + rgb("0ea5e9"),
    radius: 8pt,
    inset: 1cm
  )[
    #text(size: 16pt, weight: "bold")[
      Progress Summary
    ]
    
    #v(0.3cm)
    
    #text(size: 12pt)[
      Days Completed: #completed_days / 25 \
      Stars Collected: #total_stars / 50 \
      Progress: #calc.round((total_stars / 50) * 100, digits: 1)%
    ]
  ]
]

#pagebreak()

= Detailed Solutions

#for (i, result) in results.enumerate() {
  let day_num = i + 1
  
  [== Day #day_num: #result.title]
  
  [=== Part 1]
  [*Answer:* #result.part1]
  
  if "part1_explanation" in result {
    result.part1_explanation
  }
  
  [=== Part 2] 
  [*Answer:* #result.part2]
  
  if "part2_explanation" in result {
    result.part2_explanation
  }
  
  v(1cm)
}