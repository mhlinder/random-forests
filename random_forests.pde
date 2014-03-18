int w = 600,
    h = 600,
    bg = 255,
    fg = 0;

int pad = 50;

float mid = .5*w;
float trunkHeight = .8*h;
  float trunkWidth = .01*w;

void setup() {
  size(w+2*pad, h+2*pad);
  background(bg);
}

void draw() {
  stroke(fg);
  translate(pad, pad);

  strokeWeight(1);

  // random starting point
  float root = random(.4*w, .6*w);
  float threshold = random(0, 1);
  float y = h;
  int count = h;
  float change;
  if (random(0, 1) > 0.5) {
    change = -1;
  } else {
    change = 1;
  }
  while (count > 0) {
    count--;

    point(root, y);
    println(root, y);
    float r = random(0, 1);
    if (r > threshold) {
      root += change;
    } else {
      y--;
    }
  }
}
