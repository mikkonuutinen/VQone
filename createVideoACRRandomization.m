function sequences = createVideoACRRandomization(setup)

if strcmp(setup.random_mode,'serial') == 1
    % Create cv indexes
    round = 0;
    for i = 1 : setup.cv1
        for j = 1 : setup.cv2
            cv1_sequence(round+j) = i;
            cv2_sequence(round+j) = j;
        end
        round = round + setup.cv2;
    end
    
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    sequences = sequences';
    
elseif strcmp(setup.random_mode,'both') == 1
    
    cv1_rand_seq = randperm(setup.cv1);   % create random sequences
    round = 0;
    for i = 1 : setup.cv1
        cv2_rand_seq = randperm(setup.cv2);
        for j = 1 : setup.cv2
            cv1_sequence(round+j) = cv1_rand_seq(i);
            cv2_sequence(round+j) = cv2_rand_seq(j);
        end
        round = round + setup.cv2;
    end
    
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    sequences = sequences';
end

% Test for randomness
    [h1 p1 ] = runstest(sequences(:,1));
    [h2 p2 ] = runstest(sequences(:,2));
    
    warning off
    
    disp('Test for randomness using the runs test:')
    if h1 == 0
        disp(['CV1 in random order. h0 accepted with p = ' num2str(p1)])
    else
        disp(['CV1 not in random order. h0 rejected with  p = ' num2str(p1)])
    end
    
    if h2 == 0
        disp(['CV2 in random order. h0 accepted with p = ' num2str(p2)])
    else
        disp(['CV2 not in random order. h0 rejected with p = ' num2str(p2)])
    end

end