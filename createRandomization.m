function sequences = createRandomization(setup)

% Create random sequences for ACR standard according to the setup settings.
%
% Takes the current setup as an argument.

cv1_sequence = zeros(setup.cv1,1);
cv2_sequence = zeros(setup.cv2,1);
settings = [setup.cv1_random setup.cv2_random setup.cv1_locked setup.cv2_locked];

if settings == [0 0 1 1]
    % norm norm lock lock
    round = 0;
    if setup.dom_value == 2
        for i = 1 : setup.cv2
            for j = 1 : setup.cv1
                cv1_sequence(round+j) = j;
                cv2_sequence(round+j) = i;
            end
            round = round + setup.cv1;
        end
    else
        for i = 1 : setup.cv1
            for j = 1 : setup.cv2
                cv1_sequence(round+j) = i;
                cv2_sequence(round+j) = j;
            end
            round = round + setup.cv2;
        end
    end
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    
    %-------------------------------------------------
elseif settings == [1 1 0 0]
    % rand rand unlock unlock
    
    number_of_trials = setup.cv1 * setup.cv2;
    
    % Creates all possible CV combinations
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
    % Randomizes the CV pairs
    order_number = randperm(number_of_trials);
    sequences(3,:) = order_number;
    
    % Sort the pairs to random order
    sequences = sortrows(sequences',3)';
    
    % Pick the first two rows
    sequences = sequences(1:2,:);
    
    %-------------------------------------------------
elseif settings(1) == 1 && settings(2) == 1 && (settings(3) == 1 || settings(4) == 1)
    % rand rand (unlock/lock) (unlock/lock)
    if settings(3) == 1                 % CV1 locked
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
        
    else                                % CV2 locked
        cv2_rand_seq = randperm(setup.cv2);   % create random sequences
        round = 0;
        for i = 1 : setup.cv2
            cv1_rand_seq = randperm(setup.cv1);
            for j = 1 : setup.cv1
                cv1_sequence(round+j) = cv1_rand_seq(j);
                cv2_sequence(round+j) = cv2_rand_seq(i);
            end
            round = round + setup.cv1;
        end
    end
    
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    
    %-------------------------------------------------
elseif settings == [1 0 0 1]
    % rand norm locked unlocked
    round = 0;
    for i = 1 : setup.cv2
        cv1_rand_seq = randperm(setup.cv1);   % create random sequence
        for j = 1 : setup.cv1
            cv1_sequence(round+j) = cv1_rand_seq(j);
            cv2_sequence(round+j) = i;
        end
        round = round + setup.cv1;
    end
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    
    %-------------------------------------------------
elseif settings == [0 1 1 0]
    % norm rand locked unlocked
    round = 0;
    for i = 1 : setup.cv1
        cv2_rand_seq = randperm(setup.cv2);   % create random sequence
        for j = 1 : setup.cv2
            cv1_sequence(round+j) = i;
            cv2_sequence(round+j) = cv2_rand_seq(j);
        end
        round = round + setup.cv2;
    end
    sequences(1,:) = cv1_sequence;
    sequences(2,:) = cv2_sequence;
    
    %-------------------------------------------------
else
    disp('Impossible settings')
end

% Test for randomness
    [h1 p1 ] = runstest(sequences(1,:));
    [h2 p2 ] = runstest(sequences(2,:));
    
    warning off
    
    if h1 == 0
        disp(['CV1 in random order. h0 accepted with p = ' num2str(p1)])
    else
        disp(['CV1 not in random order. h0 rejected with p = ' num2str(p1)])
    end
    
    if h2 == 0
        disp(['CV2 in random order. h0 accepted with p = ' num2str(p2)])
    else
        disp(['CV2 not in random order. h0 rejected with p = ' num2str(p2)])
    end


















