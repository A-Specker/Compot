% This exercise simulates the rolling shutter effect by sampling the rows
% of a high speed video of a rotating ceiling fan.
clear all;
close all;
clc;

%% Read image frames into a cell array
for frm_n = 1:360
    frames{frm_n} = imread(strcat('./jpg_frames/frame_0',num2str(frm_n,'%03i'),'.jpg'));
end

%% Initialize simulated image
img = zeros(size(frames{1}),'uint8');

%% Simulate rolling shutter effect
for frm_n = 1:360
% TODO: Sample each row of the highspeed video frames and combine them into
% the rolling shutter image
end

%% Display and write result
imshow(img,[]); title('Simulation of Rolling Shutter Effect');
imwrite(img,'rolling_shutter_effect.jpg');
