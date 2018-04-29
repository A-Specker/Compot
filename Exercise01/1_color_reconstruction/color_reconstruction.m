%% color reconstruction

close all;
clear all;
clc;

% here load the images

Ir = imread('red.pgm');
Ig = imread('green.pgm');
Ib = imread('blue.pgm');

% call the gui with the loaded images
my_gui(Ir, Ig, Ib);