% trainSet, Cell array of [input images, input sensor data, target images]
% testSet, Cell array of [input images, input sensor data, target images]

ieInit;
nImg = 10;  
[trainSet, testSet] = CreateDataSet();
train_inImages = trainSet{1}; train_inSensorD = trainSet{2}; train_outImages = trainSet{3};
test_inImages = testSet{1}; test_inSensorD = testSet{2}; test_outImages = testSet{3};

%%
% Init the class we use for data simulation
% input sensor data and target images are used as inImg/outImg in L3 Simulation
l3d = l3DataSimulation();
l3d.inImg = train_inSensorD;
l3d.outImg = train_outImages;

l3d.expFrac = [2, 1, 0.5];      % No idea
l3d.loadSources(nImg, 'all');   % Which default images to load

l3t = l3TrainRidge();
% TODO: Try other options 
%  l3TrainRidge  - Ridge regression (Tikhonov)
%  l3TrainWiener - Wiener regression
%  l3TrainOLS    - Ordinary least squares

% set training parameters
l3t.l3c.cutPoints = {logspace(-1.7, -0.12, 40), []};
patchSize = 5;
l3t.l3c.patchSize = [patchSize patchSize];

% Invoke the training algorithm
l3t.train(l3d);
% % l3t.fillEmptyKernels;

%% Quantitative Metrics: CIELAB
%% Render one training image
% choose a image from train Set
train_ImgIdx = 3;
raw = train_inSensorD{train_ImgIdx}; 
target = train_outImages{train_ImgIdx}; 
input = train_inImages{train_ImgIdx};

l3r = l3Render();
cfa = cameraGet(l3d.camera, 'sensor cfa pattern');
train_outImg = l3r.render(raw, cfa, l3t);
disp(size(train_outImg));
disp(size(raw));

vcNewGraphWin([], 'wide');
input = input / max(max(input(:,:,2)));
subplot(1, 3, 1); imshow(input); title('IR Sensor Data');

target = target / max(max(target(:,:,2)));
subplot(1, 3, 2); imshow(target); title('Real Scene Image');

train_outImg = train_outImg / max(max(train_outImg(:,:,2)));
subplot(1, 3, 3); imshow(train_outImg); title('L3 Rendered Image');

train_delta_E = compute_evaluation_metric(target, train_outImg, patchSize);
disp(['train case, mean delta_E is', num2str(train_delta_E)]);

%% 
%% Test Render another scenary
% create a l3 render class
test_ImgIdx = 4;
raw = test_inSensorD{test_ImgIdx}; target = test_outImages{test_ImgIdx}; input = test_inImages{test_ImgIdx};

l3r = l3Render();
cfa = cameraGet(l3d.camera, 'sensor cfa pattern');

vcNewGraphWin([], 'wide');
input = input / max(max(input(:,:,2)));
subplot(1, 3, 1); imshow(input); title('IR Sensor Data');

target = target / max(max(target(:,:,2)));
subplot(1, 3, 2); imshow(target); title('Real Scene Image');

test_outImg = l3r.render(raw, cfa, l3t);
test_outImg = test_outImg / max(max(test_outImg(:)));
subplot(1, 3, 3); imshow(test_outImg); title('L3 Rendered Image');

test_delta_E = compute_evaluation_metric(target, test_outImg, patchSize);
disp(['test case: scenary, mean delta_E is ', num2str(test_delta_E)]);

%% Test Render another fruit
% create a l3 render class
test_ImgIdx = 3;
raw = test_inSensorD{test_ImgIdx}; target = test_outImages{test_ImgIdx}; input = test_inImages{test_ImgIdx};

l3r = l3Render();
cfa = cameraGet(l3d.camera, 'sensor cfa pattern');

vcNewGraphWin([], 'wide');
input = input / max(max(input(:,:,2)));
subplot(1, 3, 1); imshow(input); title('IR Sensor Data');

target = target / max(max(target(:,:,2)));
subplot(1, 3, 2); imshow(target); title('Real Scene Image');

test_outImg = l3r.render(raw, cfa, l3t);
test_outImg = test_outImg / max(max(test_outImg(:)));
subplot(1, 3, 3); imshow(test_outImg); title('L3 Rendered Image');

test_delta_E = compute_evaluation_metric(target, test_outImg, patchSize);
disp(['test case: male, mean delta_E is ', num2str(test_delta_E)]);
%% Test Render another female
% create a l3 render class
test_ImgIdx = 2;
raw = test_inSensorD{test_ImgIdx}; target = test_outImages{test_ImgIdx}; input = test_inImages{test_ImgIdx};

l3r = l3Render();
cfa = cameraGet(l3d.camera, 'sensor cfa pattern');

vcNewGraphWin([], 'wide');
input = input / max(max(input(:,:,2)));
subplot(1, 3, 1); imshow(input); title('IR Sensor Data');

target = target / max(max(target(:,:,2)));
subplot(1, 3, 2); imshow(target); title('Real Scene Image');

test_outImg = l3r.render(raw, cfa, l3t);
test_outImg = test_outImg / max(max(test_outImg(:)));
subplot(1, 3, 3); imshow(test_outImg); title('L3 Rendered Image');
test_delta_E = compute_evaluation_metric(target, test_outImg, patchSize);
disp(['test case: female, mean delta_E is ', num2str(test_delta_E)]);

%% Test Render another male
% create a l3 render class
test_ImgIdx = 1;
raw = test_inSensorD{test_ImgIdx}; target = test_outImages{test_ImgIdx}; input = test_inImages{test_ImgIdx};

l3r = l3Render();
cfa = cameraGet(l3d.camera, 'sensor cfa pattern');

vcNewGraphWin([], 'wide');
input = input / max(max(input(:,:,2)));
subplot(1, 3, 1); imshow(input); title('IR Sensor Data');

target = target / max(max(target(:,:,2)));
subplot(1, 3, 2); imshow(target); title('Real Scene Image');

test_outImg = l3r.render(raw, cfa, l3t);
test_outImg = test_outImg / max(max(test_outImg(:)));
subplot(1, 3, 3); imshow(test_outImg); title('L3 Rendered Image');
test_delta_E = compute_evaluation_metric(target, test_outImg, patchSize);
disp(['test case: fruit/ color checker, mean delta_E is ', num2str(test_delta_E)]);