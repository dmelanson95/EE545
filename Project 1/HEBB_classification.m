%Project 1, HEBB
%David Melanson

clf reset; clearvars; clc; close all;
format short
rng('shuffle')
num = randi(randi(100));
for i = 1:num
    rng('shuffle')
end

maxw = 10;
minw = 0;
% Training array for letter 'E' without noise
Pe = [
    1 1 1 1 1, ...
    1 -1 -1 -1 -1, ...
    1 1 1 1 -1, ...
    1 -1 -1 -1 -1, ...
    1 1 1 1 1
    ]';

% Training array for letter 'F'
Pf = [
    1 1 1 -1 -1, ...
    1 -1 -1 -1 -1, ...
    1 1 1 -1 -1, ...
    1 -1 -1 -1 -1, ...
    1 -1 -1 -1 -1 ...
    ]';

P = cat(2, Pe, Pf);

% Target for network to indicate identification of letter E is 1, F is -1
T = [1 -1];

%Initialize network
%===================================================
[R, ~] = size(P);
[S, Q] = size(T);
W0 = zeros(S, R);
B0 = ones(S, 1);

% TRAIN THE NETWORK
%===================================================
% TRAINING PARAMETERS
disp_freq = 1;
max_epoch = 1;
lr = 1;
lp.lr = lr;
lp.dr = 0;

W = W0;
B = B0;
for epoch = 1:max_epoch
    for q = 1:Q
        % PRESENTATION PHASE
        A = T(:, q);
        % LEARNING PHASE
        dW = learnhd(W, P(:,q), [], [], A, [], [], [], [], [], lp, []);
        W = W +dW;
    end
end

numBits = 20;
iterations = 10000;
identifiedE = [iterations, numBits];
identifiedF = [iterations, numBits];
for j = 1:numBits
    for i = 1:iterations
        testE = makeNoisy(Pe, j);
        resultE = hardlims(W*testE);
        if resultE > 0
            identifiedE(i, j) = 1;
        else
            identifiedE(i, j) = 0;
        end
        
        testF = makeNoisy(Pf, j);
        resultF = hardlims(W*testF);
        if resultF < 0
            identifiedF(i, j) = 1;
        else
            identifiedF(i, j) = 0;
        end
    end
end

identifiedE = sum(identifiedE)./(iterations/100);
identifiedF = sum(identifiedF)./(iterations/100);

figure;
subplot(1,2,1);
bar(1:numBits, identifiedE);
title('The Letter E')
xlabel('Number of bits flipped')
ylabel('Correct Identifications (%)')
subplot(1,2,2)
bar(1:numBits, identifiedF);
title('The Letter F')
xlabel('Number of bits flipped')
ylabel('Correct Identifications (%)')
sgtitle('Hebb Identification with Bits Flipped')

figure;
for i = 1:4
    for j = 1:5
        num = (5*(i-1))+j;
        subplot(4, 5, num);
        example = makeNoisy(Pe, num);
        example = reshape(example, [5,5])';
        hintonw(example);
        title([num2str(num), ' bit(s) flipped'])
    end
end
sgtitle('E with bits flipped')

figure;
for i = 1:4
    for j = 1:5
        num = j+(5*(i-1));
        subplot(4, 5, num);
        example = reshape(makeNoisy(Pf, num), [5,5])';
        hintonw(example);
        title([num2str(num), ' bit(s) flipped'])
    end
end
sgtitle('F with bits flipped');


fprintf('\n\nFor the letter "E":\n\n\n')
for i = 1:numBits
    fprintf('Identified %1g percent of inputs with %d bit(s) flipped.\n', identifiedE(i), i);
end
fprintf('\n\nFor the letter "F":\n\n\n')
for i = 1:numBits
    fprintf('Identified %1g percent of inputs with %d bit(s) flipped.\n', identifiedF(i), i);
end

identifiedE2 = [iterations, numBits];
identifiedF2 = [iterations, numBits];
for j = 1:numBits
    for i = 1:iterations
        testE = makeNoisy2(Pe, j);
        resultE = hardlims(W*testE);
        if resultE > 0
            identifiedE2(i, j) = 1;
        else
            identifiedE2(i, j) = 0;
        end
        
        testF = makeNoisy2(Pf, j);
        resultF = hardlims(W*testF);
        if resultF < 0
            identifiedF2(i, j) = 1;
        else
            identifiedF2(i, j) = 0;
        end
    end
end

identifiedE2 = sum(identifiedE2)./(iterations/100);
identifiedF2 = sum(identifiedF2)./(iterations/100);

figure;
subplot(1,2,1);
bar(1:numBits, identifiedE2);
title('The Letter E')
xlabel('Number of bits missing')
ylabel('Correct Identifications (%)')
subplot(1,2,2)
bar(1:numBits, identifiedF2);
title('The Letter F')
xlabel('Number of bits missing')
ylabel('Correct Identifications (%)')
sgtitle('Hebb Identification with Bits Missing')


figure;
for i = 1:4
    for j = 1:5
        num = j+(5*(i-1));
        subplot(4, 5, num);
        example = reshape(makeNoisy2(Pf, num), [5,5])';
        hintonw(example);
        title([num2str(num), ' bit(s) missing'])
    end
end
sgtitle('F with bits missing')

figure;
for i = 1:4
    for j = 1:5
        num = j+(5*(i-1));
        subplot(4, 5, num);
        example = reshape(makeNoisy2(Pe, num), [5,5])';
        hintonw(example);
        title([num2str(num), ' bit(s) missing'])
    end
end
sgtitle('E with bits missing')

fprintf('\n\nFor the letter "E":\n\n\n')
for i = 1:numBits
    fprintf('Identified %1g percent of inputs with %d bit(s) missing.\n', identifiedE2(i), i);
end
fprintf('\n\nFor the letter "F":\n\n\n')
for i = 1:numBits
    fprintf('Identified %1g percent of inputs with %d bit(s) missing.\n', identifiedF2(i), i);
end


%function that takes an array and a number of bits to flip and does that
function retArr = makeNoisy(passArr, numBits)
    diffEl = 0;
    retArr = passArr;
    while(diffEl ~= numBits)
        row = randi(25);
        retArr(row, 1) = -1*(passArr(row, 1));
        diffEl = sum(sum(retArr ~= passArr));
    end
end

%function that takes an array and a number of bits to flip and does that
function retArr = makeNoisy2(passArr, numBits)
    diffEl = 0;
    retArr = passArr;
    while(diffEl ~= numBits)
        row = randi(25);
        if passArr(row, 1) == 0
            retArr(row, 1) = 1;
        else
            retArr(row, 1) = 0;
        end
        diffEl = sum(sum(retArr ~= passArr));
    end
end

