int w = 600,
    h = 600,
    bg = 255,
    fg = 0;

int pad = 50,
    n = 500,
    nBranch = 100;

float threshold = 0.5,
      trunkWidth = .01*w,
      stepWidth = .5*trunkWidth,
      mid = .5*w;

float[][] branch;
float[][][] branches = new float[nBranch][n][2];

int branchCount = 0;

void setup() {
  size(w+2*pad, h+2*pad);
  background(bg);

  translate(pad, pad);

  // random starting point
  branch = randomTrunk();
  branches[branchCount] = branch;
  branchCount++;
  drawBranch(branch);
}

void draw() {
  translate(pad, pad);

  float r = random(0, 1);
  if (r < 0.5) {
    branch = randomTrunk();
  } else {
    int ix = floor(random(0, 1) * branchCount);
    branch = branches[ix];
  }
  branch = jitter(branch);
  branch = branchOut(branch);

  branches[branchCount] = branch;
  branchCount++;

  drawBranch(branch);
  delay(1000);
}

// generate a random trunk
float[][] randomTrunk() {
  float[][] trunk = new float[n][2];
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

    r = random(0, 1);
    if (r < 0.75) {
      trunk[i][1] = trunk[i-1][1] - 1;
    } else {
      trunk[i][1] = trunk[i-1][1];
    }
  }

  return trunk;
}

float[][] branchOut(float[][] branch) {
  int branchPoint = floor(random(n/4, n));
  float threshold = random(0, 1);

  float hi, lo;
  if (threshold < 0.5) {
    hi = mid;
    lo = 0;
  } else {
    hi = w;
    lo = mid;
  }

  for (int i = branchPoint; i < branch.length; i++) {
    float r = random(0, 1);

    if (r < threshold) {
      if (branch[i-1][0] - stepWidth > lo) {
        branch[i][0] = branch[i-1][0] - stepWidth;
      }
    } else {
      if (branch[i-1][0] + stepWidth < hi) {
        branch[i][0] = branch[i-1][0] + stepWidth;
      }
    }

    float thresholdChange = random(-.5, .5);
    if (threshold + thresholdChange > 0 && threshold + thresholdChange < 1) {
      threshold = threshold + thresholdChange;
    }
  }
  return branch;
}

// move a branch left or right, for overlap
float[][] jitter(float[][] branch) {
  float r = random(0, 1);
  for (int i = 0; i < branch.length; i++) {
    if (r < threshold) {
      branch[i][0] = branch[i][0] - stepWidth;
    } else {
      branch[i][0] = branch[i][0] + stepWidth;
    }
  }
  return branch;
}

void drawBranch(float[][] branch) {
  strokeWeight(1);
  for (int i = 1; i < branch.length; i++) {
    line(branch[i-1][0], branch[i-1][1], branch[i][0], branch[i][1]);
  }
}
