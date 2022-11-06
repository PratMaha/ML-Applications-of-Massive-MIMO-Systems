%% Create Deep Learning Network Architecture with Pretrained Parameters
% Script for creating the layers for a deep learning network with the following 
% properties:
%%
% 
%  Number of layers: 13
%  Number of connections: 12
%  Pretrained parameters file: /Users/prateek/Documents/College/Academics/3-2/SOP-5G/init_param.mat
%% Load the Pretrained Parameters and training and validation data
clear all;
close all;
clc;
data = load("final_data.txt");
%Normalising the data
data(:,1:24)=log10(data(:,1:24));
data(:,25:28)=max(-20, log10(data(:,25:28)));
input_tr=data(1:1500,1:24);
output_tr=data(1:1500,25:28);
input_val=data(1001:1500,1:24);
output_val=data(1001:1500,25:28);
input_test=data(1501:2000,1:24);
output_test=data(1501:2000,25:28);
input_tr=transpose(input_tr);
output_tr=transpose(output_tr);
input_val=transpose(input_val);
output_val=transpose(output_val);
input_test=transpose(input_test);
output_test=transpose(output_test);
params = load("/Users/prateek/Documents/College/Academics/3-2/SOP-5G/init_param.mat");
%% Create Array of Layers

layers = [
    sequenceInputLayer(24,"Name","sequence")
    fullyConnectedLayer(128,"Name","fc_6")
    eluLayer(1,"Name","elu_1")
    fullyConnectedLayer(64,"Name","fc_1")
    reluLayer("Name","relu_1")
    fullyConnectedLayer(32,"Name","fc_2")
    eluLayer(1,"Name","elu_2")
    fullyConnectedLayer(16,"Name","fc_3")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(8,"Name","fc_4")
    eluLayer(1,"Name","elu_3")
    fullyConnectedLayer(4,"Name","fc_5")
    regressionLayer("Name","regressionoutput")];

%% Train the network
miniBatchSize = 1;
options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',2000, ...
    'MiniBatchSize',miniBatchSize, ...
    'ValidationData',{input_val,output_val}, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(input_tr,output_tr,layers,options);

%% Test the data
output_pred = predict(net,input_test);
f=((output_pred-output_test).*(output_pred-output_test))/500;
disp(sum(sum(f)));

%% Plot Layers

plot(layerGraph(layers));