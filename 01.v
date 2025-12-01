import os

// part 1
lines := os.read_lines('input')!
mut dial := 50
mut count := 0
for line in lines {
  dir := line[0]
  turns := line[1..].int()
  dial += turns * if dir == `L` { -1 } else { 1 }
  for dial > 99 {
    dial -= 100
  }
  for dial < 0 {
    dial += 100
  }
  if dial == 0 {
    count++
  }
}
println(count)

// part 2
dial = 50
count = 0
for line in lines {
  dir := line[0]
  turns := line[1..].int()
  delta := turns * if dir == `L` { -1 } else { 1 }
  for _ in 0..turns {
    dial += delta
    for dial > 99 {
      dial -= 100
    }
    for dial < 0 {
      dial += 100
    }
    if dial == 0 {
      count++
    }
  }
}
println(count)
