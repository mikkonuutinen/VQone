function sequences = createTripletRandomization(setup)
% Function that creates stimuli vectors for the triplet standard.
%
% Takes the current setup file as an argument. CV2 amount must be from the 
% set: {3, 7, 9, 13, 15, 19, 21, 25, 27}

cv1 = setup.cv1;
cv2 = setup.cv2;
rand_mode = setup.random_mode;

% cv1 = 3;
% cv2 = 3;
% rand_mode = 'both';

% Number of combinations for each content
N = cv2 * (cv2 - 1) / 6;

% Make the combinations without duplication (See triplet standard)
stim = [0 0 0];
if cv2 == 3 %--------------------------------------------------------------
    stim = [1 2 3];
elseif cv2 == 7 %----------------------------------------------------------
    for i = 1 : N
        stim(i,:) = [mmod(i) mmod(i+1) mmod(i+3)];
    end
elseif cv2 == 9 %----------------------------------------------------------
    index = 1;
    for i = [1 4 7]
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+3)];
        index = index+1;
    end
    for i = [2 5 8]
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+3)];
        index = index+1;
    end
    for i = [1 4 7]
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+5)];
        index = index+1;
    end
    for i = [1 4 7]
        stim(index,:) = [mmod(i) mmod(i+4) mmod(i+8)];
        index = index+1;
    end
elseif cv2 == 13 %---------------------------------------------------------
    index = 1;
    for i = 1 : 13
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+7)];
        index = index+1;
    end
    for i = 1:13
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+4)];
        index = index+1;
    end
elseif cv2 == 15 %---------------------------------------------------------
    index = 1;
    for i = 1:15
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+8)];
        index = index+1;
    end
    for i = 1:15
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+4)];
        index = index+1;
    end
    for i = 1:5
        stim(index,:) = [mmod(i) mmod(i+5) mmod(i+10)];
        index = index+1;
    end
elseif cv2 == 19 %---------------------------------------------------------
    index = 1;
    for i = 1:19
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+10)];
        index = index+1;
    end
    for i = 1:19
        stim(index,:) = [mmod(i) mmod(i+3) mmod(i+7)];
        index = index+1;
    end
    for i = 1:19
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+6)];
        index = index+1;
    end
elseif cv2 == 21 %---------------------------------------------------------
    index = 1;
    for i = 1:21
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+10)];
        index = index+1;
    end
    for i = 1:21
        stim(index,:) = [mmod(i) mmod(i+3) mmod(i+8)];
        index = index+1;
    end
    for i = 1:21
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+6)];
        index = index+1;
    end
    for i = 1:7
        stim(index,:) = [mmod(i) mmod(i+7) mmod(i+14)];
        index = index+1;
    end
elseif cv2 == 25 %---------------------------------------------------------
    index = 1;
    for i = 1:25
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+12)];
        index = index+1;
    end
    for i = 1:25
        stim(index,:) = [mmod(i) mmod(i+3) mmod(i+11)];
        index = index+1;
    end
    for i = 1:25
        stim(index,:) = [mmod(i) mmod(i+4) mmod(i+9)];
        index = index+1;
    end
    for i = 1:25
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+7)];
        index = index+1;
    end
elseif cv2 == 27 %---------------------------------------------------------
    index = 1;
    for i = 1:27
        stim(index,:) = [mmod(i) mmod(i+1) mmod(i+13)];
        index = index+1;
    end
    for i = 1:27
        stim(index,:) = [mmod(i) mmod(i+3) mmod(i+11)];
        index = index+1;
    end
    for i = 1:27
        stim(index,:) = [mmod(i) mmod(i+4) mmod(i+10)];
        index = index+1;
    end
    for i = 1:27
        stim(index,:) = [mmod(i) mmod(i+2) mmod(i+7)];
        index = index+1;
    end
    for i = 1:9
        stim(index,:) = [mmod(i) mmod(i+9) mmod(i+18)];
        index = index+1;
    end
end

disp(['Number of combinations in each content: ' num2str(N)])
disp('Pipe indices: ')
disp(stim)

% Place the combinations to the stimulus vectors
sequences = zeros(N,6);
if strcmp(rand_mode,'serial')
    round = 0;
    for i = 1 : cv1
        for j = 1 : N
            sequences(round+j,1) = i;
            sequences(round+j,2) = stim(j,1);
            
            sequences(round+j,3) = i;
            sequences(round+j,4) = stim(j,2);
            
            sequences(round+j,5) = i;
            sequences(round+j,6) = stim(j,3);
        end
        round = round + N;
    end
else % Random
    cv1_vector = randperm(cv1);
    round = 0;
    for i = 1 : cv1
        cv2_vector = randperm(N);
        for j = 1 : N
            cv1_index = cv1_vector(i);
            cv2_index = cv2_vector(j);
            sequences(round+j,1) = cv1_index;
            sequences(round+j,2) = stim(cv2_index,1);
            
            sequences(round+j,3) = cv1_index;
            sequences(round+j,4) = stim(cv2_index,2);
            
            sequences(round+j,5) = cv1_index;
            sequences(round+j,6) = stim(cv2_index,3);
        end
        round = round + N;
    end
end

disp('Stimulus vectors:')
disp(sequences)



% Nested function for calculating the modified modulo
    function out = mmod(in)
        out = 1 + mod(in-1,cv2);
    end

end



