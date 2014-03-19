int w = 600,
    h = 600,
    bg = 255,
    fg = 0;

int pad = 50,
    n = 6,
    nBranch = 15;

float threshold = 0.5,
      trunkWidth = .01 * w,
      rootWidth = .05 * w,
      stepLength = .1 * h,
      stepSize = .05 * h,
      mid = .5*w;

float[][] branch;
float[][][] branches = new float[nBranch][n][2];

void setup() {
  size(w+2*pad, h+2*pad);
  background(bg);
  branch = randomTrunk();

  for (int i = 0; i < nBranch; i++) {
    // random starting point
    float r = random(0, 1);

    if (i == 0 || r < .7) {
      branch = randomTrunk();
    } else {
      int ix = floor(random(0, i));
      branch = branches[ix];
      branch = jitter(branch);
    }

    drawBranch(branch);

    branches[i] = branch;
    delay(500);
  }
  save("tree.png");
}

// generate a random trunk
float[][] randomTrunk() {
  float[][] trunk = new float[n][2];
  // root
  trunk[0][0] = random(mid - rootWidth, mid + rootWidth);
  trunk[0][1] = h;

  // bottom of trunk
  trunk[1][0] = random(mid - trunkWidth, mid + trunkWidth);
  trunk[1][1] = random(h - .01*h, h - .05*h);

  // top of trunk
  trunk[2][0] = random(mid - trunkWidth, mid + trunkWidth);
  trunk[2][1] = random(trunk[1][1] - .2*h, trunk[1][1] - .3*h);

  float theta, r;
  theta = random(PI + PI/3, TWO_PI - PI/3);
  for (int i = 3; i < trunk.length; i++) {
    theta = theta + random(-PI/3, PI/3);
    r = random(stepLength - stepSize, stepLength + stepSize);
    
    trunk[i][0] = trunk[i-1][0] + r*cos(theta);
    trunk[i][1] = trunk[i-1][1] + r*sin(theta);
  }

  return trunk;
}

float[][] jitter(float[][] branch) {
  float[][] newBranch = new float[branch.length][2];

  for (int i = 0; i < branch.length; i++) {
    newBranch[i][0] = branch[i][0] + random(-.1*stepSize, .1*stepSize);
    newBranch[i][1] = branch[i][1];
  }

  return newBranch;
}

void drawBranch(float[][] branch) {
  for (int i = 1; i < branch.length; i++) {
    strokeWeight(2);
    line(branch[i-1][0], branch[i-1][1], branch[i][0], branch[i][1]);
  }
}
