function [psnr] = PSNR(image, reference)
    mse = MSE(image, reference);
    psnr = 20*log10(1/sqrt(mse));
end