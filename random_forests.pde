int w = 600,
    h = 600,
    bg = 255,
    fg = 0;

int pad = 50,
    n = 600;

float threshold = 0.5,
      trunkWidth = .05*w,
      stepWidth = .1*trunkWidth,
      mid = .5*w;

float[][] branch;

void setup() {
  size(w+2*pad, h+2*pad);
  background(bg);

  translate(pad, pad);

  // random starting point
  branch = randomTrunk();
  drawBranch(branch);
}

void draw() {
  translate(pad, pad);

  branch = randomTrunk();
  drawBranch(branch);
  delay(1000);
}

// generate a random trunk
float[][] randomTrunk() {
  float[][] trunk = new float[n][n];
  trunk[0][0] = random(mid - trunkWidth, mid + trunkWidth);
  trunk[0][1] = h;

  // random walk within (mid-trunkWidth, mid+trunkWidth)
  for (int i = 1; i < n; i++) {
    float r = random(0, 1);

    if (r < threshold) {
      if (trunk[i-1][0] - stepWidth >= mid - trunkWidth) {
        trunk[i][0] = trunk[i-1][0] - stepWidth;
      } else {
        trunk[i][0] = trunk[i-1][0] + stepWidth;
      }
    } else {
      if (trunk[i-1][0] + stepWidth <= mid + trunkWidth) {
        trunk[i][0] = trunk[i-1][0] + stepWidth;
      } else {
        trunk[i][0] = trunk[i-1][0] - stepWidth;
      }
    }

    trunk[i][1] = trunk[i-1][1] - 1;
  }

  return trunk;
}

// jitter a given branch, for visual overlap
float[][] jitter(float[][] branch) {

  float[][] newBranch = new float[n][n];

  for (int i = 0; i < branch.length; i++) {
    float r = random(0, 1);

    float lo = .33;
    float hi = .66;

    if (r < lo) {
      newBranch[i][0] = branch[i][0] - stepWidth;
    } else if (r > hi) {
      newBranch[i][0] = branch[i][0] + stepWidth;
    } else {
      newBranch[i][0] = branch[i][0];
    }
    newBranch[i][1] = branch[i][1];

  }
  return newBranch;
}

void drawBranch(float[][] branch) {
  strokeWeight(5);
  for (int i = 1; i < branch.length; i++) {
    line(branch[i-1][0], branch[i-1][1], branch[i][0], branch[i][1]);
  }
}
