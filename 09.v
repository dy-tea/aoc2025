import os
import math

fn react_area(x1 i64, y1 i64, x2 i64, y2 i64) u64 {
  dx := math.abs(x1 - x2) + 1
  dy := math.abs(y1 - y2) + 1
  return u64(dx) * u64(dy)
}

fn point_in_polygon(x i64, y i64, polygon [][]i64) bool {
  mut inside := false
  n := polygon.len
  for i := 0; i < n; i++ {
    j := (i + 1) % n
    xi, yi := polygon[i][0], polygon[i][1]
    xj, yj := polygon[j][0], polygon[j][1]
    if (yi == y && yj == y && ((xi <= x && x <= xj) || (xj <= x && x <= xi))) ||
        (xi == x && xj == x && ((yi <= y && y <= yj) || (yj <= y && y <= yi))) {
      return true
    }
    if (yi > y) != (yj > y) {
      slope := f64(xj - xi) / f64(yj - yi)
      intersect_x := f64(xi) + slope * f64(y - yi)
      if f64(x) < intersect_x {
        inside = !inside
      }
    }
  }
  return inside
}

fn rect_in_polygon(x1 i64, y1 i64, x2 i64, y2 i64, polygon [][]i64) bool {
  min_x := math.min(x1, x2)
  max_x := math.max(x1, x2)
  min_y := math.min(y1, y2)
  max_y := math.max(y1, y2)
  corners := [
    [min_x, min_y],
    [min_x, max_y],
    [max_x, min_y],
    [max_x, max_y],
  ]
  for corner in corners {
    if !point_in_polygon(corner[0], corner[1], polygon) {
      return false
    }
  }
  width := max_x - min_x
  height := max_y - min_y
  samples := math.max(i64(10), math.max(height, width) / 1000)
  for i := 0; i <= samples; i++ {
    t := f64(i) / f64(samples)
    test_x := min_x + i64(f64(width) * t)
    if !point_in_polygon(test_x, min_y, polygon) || !point_in_polygon(test_x, max_y, polygon) {
      return false
    }
    test_y := min_y + i64(f64(height) * t)
    if !point_in_polygon(min_x, test_y, polygon) || !point_in_polygon(max_x, test_y, polygon) {
      return false
    }
  }
  mid_x := (min_x + max_x) / 2
  mid_y := (min_y + max_y) / 2
  if !point_in_polygon(mid_x, mid_y, polygon) {
    return false
  }
  return true
}

lines := os.read_lines('input')!
coords := lines.map(fn (line string) []i64 {
  x, y := line.split_once(',') or { panic('invalid input') }
  return [x.i64(), y.i64()]
})

// part 1
mut max_area := u64(0)
for i := 0; i != coords.len - 1; i++ {
  x, y := coords[i][0], coords[i][1]
  for j := i + 1; j != coords.len; j++ {
    xx, yy := coords[j][0], coords[j][1]
    area := react_area(x, y, xx, yy)
    if area > max_area {
      max_area = area
    }
  }
}
println(max_area)

// part 2
max_area = 0
for i := 0; i < coords.len - 1; i++ {
  x, y := coords[i][0], coords[i][1]
  for j := i + 1; j < coords.len; j++ {
    xx, yy := coords[j][0], coords[j][1]
    if x == xx || y == yy {
      continue
    }
    if rect_in_polygon(x, y, xx, yy, coords) {
      area := react_area(x, y, xx, yy)
      if area > max_area {
        max_area = area
      }
    }
  }
}
println(max_area)
