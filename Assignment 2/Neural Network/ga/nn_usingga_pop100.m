clear all
clc

max_runs = 3;

load wilt.mat


% Number of neurons
n = 10;

% Number of attributes and number of classifications
[n_attr, ~]  = size(training_data');
[n_class, ~] = size(training_label');

% Initialize neural network
net = feedforwardnet(n);

% Configure the neural network for this dataset
net = configure(net, training_data', training_label'); %view(net);

fun = @(w) mse_test(w, net, training_data', training_label');
iter = [50 100 500 1000 2000];
for it = 1:length(iter)
    xs = [];
    globalResults = zeros(3,max_runs);
    for run = 1:max_runs
        % Setting the Genetic Algorithms tolerance for
        % minimum change in fitness function before
        % terminating algorithm to 1e-8 and displaying
        % each iteration's results.
        options = gaoptimset ('TolFun',1e-8,'Generation',iter(it), 'PopInitRange', [-20;20],'PopulationSize', 100);
        
        tic
        [x, fval, flag, output] = ga(fun, 82, options);
        globalResults(3,run) = toc;
        xs = [ xs;x ];
        globalResults(1,run) = output.funccount;
        globalResults(2,run) = fval;
    end
    save(['result_pop100_iter' num2str(iter(it)) '.mat']);
    sprintf('GA - population size 100 - iter %d : \n', iter(it))
    display ( ['mean elapsed time for 1 run: ' num2str(mean(globalResults(3,:))) ]);
    display ( ['mean f-evals: ' num2str(mean(globalResults(1,:))) ]  );
    display ( ['average f-val: ' num2str(mean(globalResults(2,:))) ]  );
    display ( ['best f-val: ' num2str(max(globalResults(2,:)))]  );
    [~, bestindex] = max(globalResults(2,:));
    display ( ['performance f-val: ' num2str( performnnet(xs(bestindex,:), net, test_data',test_target)) ]);
end




