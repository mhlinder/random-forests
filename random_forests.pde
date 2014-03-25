int w = 600,
    h = 600,
    bg = 255,
    fg = 0;

int pad = 50,
    n = 200,
    nBranch = 15;

float threshold = 0.5,
      stepLength = .001 * h / 2,
      stepSize = .005 * h / 2,
      mid = .5*w;

float[][] branch;
float[][][] branches = new float[nBranch][n][2];

void setup() {
  size(w+2*pad, h+2*pad);
  background(bg);

 for (int i = 0; i < nBranch; i++) {
   // random starting point
   float r = random(0, 1);

    if (i == 0 || r < .1) {
     branch = randomTrunk();
   } else {
     int ix = floor(random(0, i));
     branch = branches[ix];
     branch = jitter(branch);
     branch = branchOut(branch);
   }

   drawBranch(branch);

   branches[i] = branch;
 }
 // save("tree.png");
}

// generate a random trunk
float[][] randomTrunk() {
  float[][] trunk = new float[n][2];

  trunk[0][0] = mid + random(-20*stepLength, 20*stepLength);
  trunk[0][1] = h;

  float theta = 3*HALF_PI;
  float r;

  for (int i = 1; i < trunk.length; i++) {
    r = random(stepSize - stepLength, stepSize + stepLength);
    float adj;
    if (i < trunk.length / 3) {
      adj = random(-THIRD_PI/12, THIRD_PI/12);
    } else {
      adj = random(-THIRD_PI/5, THIRD_PI/5);
    }
    theta = theta + adj;

    trunk[i][0] = trunk[i-1][0] + r*cos(theta);
    trunk[i][1] = trunk[i-1][1] + r*sin(theta);
  }

  return trunk;
}

float[][] jitter(float[][] branch) {
  float[][] newBranch = new float[branch.length][2];

  for (int i = 0; i < branch.length; i++) {
    newBranch[i][0] = branch[i][0] + random(-.5*stepSize, .5*stepSize);
    newBranch[i][1] = branch[i][1];
  }

  return newBranch;
}

float[][] branchOut(float[][] branch) {
  float[][] newBranch = new float[branch.length][2];

  int branchPoint = floor(random(branch.length/2, branch.length));
  float theta = random(PI, TWO_PI);
  float r;

  for (int i = 0; i < branch.length; i++) {
    if (i < branchPoint) {
      newBranch[i] = branch[i];
    } else {
      r = random(stepSize - stepLength, stepSize + stepLength);
      float adj = random(-THIRD_PI/5, THIRD_PI/5);
      theta = theta + adj;

      newBranch[i][0] = newBranch[i-1][0] + r*cos(theta);
      newBranch[i][1] = newBranch[i-1][1] + r*sin(theta);
    }
  }

  return newBranch;
}

void drawBranch(float[][] branch) {
  // strokeWeight(8);
  point(branch[0][0], branch[0][1]);
  for (int i = 1; i < branch.length; i++) {
    // strokeWeight(8);
    point(branch[i][0], branch[i][1]);
    strokeWeight(3);
    line(branch[i-1][0], branch[i-1][1], branch[i][0], branch[i][1]);
  }
}
