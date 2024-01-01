classdef SRCNN_model < handle
    properties
        patchExtraction;
        nonLinearity;
        reconstruction;
    end

    methods
        function obj = SRCNN_model()
            obj.patchExtraction = initializePatchExtraction();
            obj.nonLinearity = initializeNonLinearity();
            obj.reconstruction = initializeReconstruction();
        end

        function network = initializePatchExtraction()
            net = layerGraph();
            net.addLayers({
                'convolution', {'size', [9 9]; 'stride', [1 1]; 'dilation', [1 1]; 'numFilters', 64}, ...
                'batchNormalization', {}, ...
                'activation', {'functionName', 'relu'}
            });
            return net;
        end

        function network = initializeNonLinearity()
            net = layerGraph();
            net.addLayers({
                'convolution', {'size', [1 1]; 'stride', [1 1]; 'dilation', [1 1]; 'numFilters', 32}, ...
                'batchNormalization', {}, ...
                'activation', {'functionName', 'relu'}
            });
            return net;
        end

        function network = initializeReconstruction()
            net = layerGraph();
            net.addLayers({
                'convolution', {'size', [5 5]; 'stride', [1 1]; 'dilation', [1 1]; 'numFilters', 3}, ...
                'batchNormalization', {}, ...
                'activation', {'functionName', 'tanh'} % tanh for normalization purposes
            });
            return net;
        end

        function activation = relu(obj, activation)
            activation = max(activation, 0);
        end
    end
end