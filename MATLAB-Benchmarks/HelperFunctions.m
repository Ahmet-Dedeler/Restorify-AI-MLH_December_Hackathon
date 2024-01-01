function sortedFiles = dir_sort(directoryPath)
    rawListing = dir(fullfile(pwd(), directoryPath));
    sortedFiles = sortrows(@(x) x.name, rawListing);
end

function blurredImg = gaussian_blur(inputImg, kernelSize, sigma)
    if nargin < 3 || isempty(sigma)
        sigma = round(kernelSize / 4);
    end

    fspecialKernel = fspecial('gaussian', kernelSize, sigma);
    filteredImg = conv2(double(inputImg), fspecialKernel, 'same');
    blurredImg = uint8(abs(filteredImg));
end

function resizedImg = resize_bicubic(inputImg, targetWidth, targetHeight)
    interpMethod = 'spline'; % bicubic interpolation
    resamplingFactors = [targetWidth / size(inputImg, 2), targetHeight / size(inputImg, 1)];
    resizedImg = imresize(inputImg, resamplingFactors, interpMethod);
end

function downscaledImg = downscale(inputImg, scaleFactor)
    h = size(inputImg, 1);
    w = size(inputImg, 2);

    newHeight = floor(h / scaleFactor);
    newWidth = floor(w / scaleFactor);

    rescaledImg = imresize(inputImg, [newHeight, newWidth], 'bicubic');
    downscaledImg = zeros(newHeight, newWidth, size(inputImg, 3), class(inputImg));
    downscaledImg = cat(3, downscaledImg, rescaledImg, downscaledImg);
end

function upscaledImg = upscale(inputImg, scaleFactor)
    h = size(inputImg, 1);
    w = size(inputImg, 2);

    newHeight = ceil(h * scaleFactor);
    newWidth = ceil(w * scaleFactor);

    rescaledImg = imresize(inputImg, [newHeight, newWidth], 'bicubic');
    upscaledImg = zeros(newHeight, newWidth, size(inputImg, 3), class(inputImg));
    upscaledImg = cat(3, upscaledImg, rescaledImg, upscaledImg);
end

function degradedImg = make_lr(inputImg, scaleFactor)
    degradedImg = downscale(inputImg, scaleFactor);
    degradedImg = resize_bicubic(degradedImg, size(inputImg, 1), size(inputImg, 2));
end

function transformedImg = random_transform(inputImg)
    numRotations = 3;
    rotationOptions = [1, numRotations];

    numFlips = 2;
    flipOptions = [1, numFlips];

    operationIdx = datasample(rotationOptions, 1) + datasample(flipOptions, 1) * 3;

    switch operationIdx
        case 1
            transformedImg = inputImg;
        case 2
            transformedImg = rot90(inputImg, 1);
        case 3
            transformedImg = rot90(inputImg, 2);
        case 4
            transformedImg = rot90(inputImg, 3);
        case 5
            transformedImg = fliplr(inputImg);
        otherwise
            transformedImg = flipud(inputImg);
    end
end

function shuffledData = shuffle(data, labels)
    idx = randperm(length(data));
    shuffledData = {data(idx)', labels(idx)'};
end

function ycbcr = rgb2ycrcb(rgb)
    rgb = mat2gray(rgb);
    r = rgb(:, :, 1);
    g = rgb(:, :, 2);
    b = rgb(:, :, 3);

    y = 0.299 * r + 0.587 * g + 0.114 * b;
    cb = -0.168736 * r - 0.331264 * g + 0.5 * b;
    cr = 0.5 * r - 0.418688 * g - 0.081312 * b;

    ycbcr = cat(3, mat2gray(y), mat2gray(cb), mat2gray(cr));
end

function rgb = ycrcb2rgb(ycbcr)
    ycbcr = mat2gray(ycbcr);
    y = ycbcr(:, :, 1);
    cb = ycbcr(:, :, 2);
    cr = ycbcr(:, :, 3);

    r = y + 1.402 * cr;
    g = y - 0.344136 * cb - 0.714136 * cr;
    b = y + 1.772 * cb;

    rgb = cat(3, mat2gray(r), mat2gray(g), mat2gray(b));
end