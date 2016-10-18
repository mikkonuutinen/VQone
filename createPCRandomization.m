function sequences = createPCRandomization(setup)

% Function for creating the random stimulus sequences for two displays.
%
% Takes the current setup as an argument.

cv1 = setup.cv1;
cv2 = setup.cv2;
rand_mode = setup.random_mode;
pair_repetition = setup.pair_repetition;

% cv1 = 3;
% cv2 = 6;
% rand_mode = 'serial';
% pair_repetition = 0;

% Create cv indexes
round = 0;
for i = 1 : cv1
    for j = 1 : cv2
        cv1_sequence(round+j) = i;
        cv2_sequence(round+j) = j;
    end
    round = round + cv2;
end

sequences(1,:) = cv1_sequence;
sequences(2,:) = cv2_sequence;

%Sort cv indexes according to the settings
%--------------------------------------------------------------------------
if strcmp(rand_mode,'serial') == 1
    order = nchoosek(1:cv2,2)';
    
    if pair_repetition == 1
        new_order(1,:) = order(2,:);
        new_order(2,:) = order(1,:);
        order = [order new_order];
    end
    
    for i = 2 : cv1
        newnew_order = (nchoosek(1:cv2,2)+((i-1)*cv2))';
        
        if pair_repetition == 1
            new_order(1,:) = newnew_order(2,:);
            new_order(2,:) = newnew_order(1,:);
            newnew_order = [newnew_order new_order];
        end
        
        order = [order newnew_order];
    end
    
    measure = order(1,:);
    
    for j = 1 : length(measure)
        indexes(1,j) = sequences(1,order(1,j));
        indexes(2,j) = sequences(2,order(1,j));
        
        indexes(3,j) = sequences(1,order(2,j));
        indexes(4,j) = sequences(2,order(2,j));
    end
    
    indexes = indexes';
    %----------------------------------------------------------------------
elseif strcmp(rand_mode,'both') == 1
    
    % Sort the cv2s to random order
    order = nchoosek(1:cv2,2);
    how_many = nchoosek(cv2,2);
    
    if pair_repetition == 1
        how_many = 2 * nchoosek(cv2,2);
        new_order(:,1) = order(:,2);
        new_order(:,2) = order(:,1);
        order = vertcat(order,new_order);
    end
    
    % Randomize rows
    order(:,3) = randperm(how_many);
    order = sortrows(order,3);
    
    for i = 2 : cv1
        add_order = nchoosek(1:cv2,2)+((i-1)*cv2)';
        
        if pair_repetition == 1
            new_order(:,1) = add_order(:,2);
            new_order(:,2) = add_order(:,1);
            add_order = vertcat(add_order,new_order);
        end
        
        % Randomize rows
        add_order(:,3) = randperm(how_many);
        add_order = sortrows(add_order,3);
        
        order = vertcat(order,add_order);
    end
    
    measure = order(:,1);
    
    for j = 1 : length(measure)
        indexes(1,j) = sequences(1,order(j,1));
        indexes(2,j) = sequences(2,order(j,1)); %#ok<*AGROW>
        
        indexes(3,j) = sequences(1,order(j,2));
        indexes(4,j) = sequences(2,order(j,2));
    end
    
    indexes = indexes';
    
    % Sort the cv1s to random order
    random_order = randperm(cv1);
    reader = 1;
    new_order = zeros(length(measure),1);
    
    if pair_repetition == 1
        step = 2 * nchoosek(cv2,2);
    else
        step = nchoosek(cv2,2);
    end
    
    for i = 1 : step : step*cv1
        for j = i : i + step-1
            new_order(j) = random_order(reader);
        end
        reader = reader + 1;
    end
    
    % Sort the rows according to column 5. Then remove the 5th column.
    indexes(:,5) = new_order;
    indexes = sortrows(indexes,5);
    indexes = indexes(:,1:4);
end
%----------------------------------------------------------------------
sequences = indexes;

% Test for randomness
[h1_1 p1_1 ] = runstest(sequences(:,1));
[h1_2 p1_2 ] = runstest(sequences(:,2));
[h2_1 p2_1 ] = runstest(sequences(:,3));
[h2_2 p2_2 ] = runstest(sequences(:,4));

warning off

disp('Test for randomness using the runs test:')
if h1_1 == 0
   disp(['CV1_1 in random order. h0 accepted with p = ' num2str(p1_1)])
else
    disp(['CV1_1 not in random order. h0 rejected with p = ' num2str(p1_1)])
end
if h1_2 == 0
   disp(['CV1_2 in random order. h0 accepted with p = ' num2str(p1_2)])
else
    disp(['CV1_2 not in random order. h0 rejected with p = ' num2str(p1_2)])
end
if h2_1 == 0
   disp(['CV2_1 in random order. h0 accepted with p = ' num2str(p2_1)])
else
    disp(['CV2_1 not in random order. h0 rejected with p = ' num2str(p2_1)])
end
if h2_2 == 0
   disp(['CV2_2 in random order. h0 accepted with p = ' num2str(p2_2)])
else
    disp(['CV2_2 not in random order. h0 rejected with p = ' num2str(p2_2)])
end

end












