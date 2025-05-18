% Step 1: Generate a simple connected unweighted undirected network with 10 nodes
n = 10; % Number of nodes
G = rand(n) < 0.5; % Create a random adjacency matrix with probability
G = triu(G, 1) + triu(G, 1)'; % Make the matrix symmetric (undirected)
G = G - diag(diag(G)); % Remove self-loops

% Step 2: Calculate the Laplacian matrix
L = diag(sum(G, 2)) - G; % Laplacian matrix

% Step 3: Set a and b
a = 0.3;
alpha = 1;

% Step 4: Calculate shortest path l_ik for each i ≠ k and calculate π_ik
G_graph = graph(G); % Create a graph object from the adjacency matrix
n_nodes = size(G, 1); % Number of nodes
pi = zeros(n_nodes, n_nodes); % Initialize the pi matrix

for k = 1:n_nodes
    for i = 1:n_nodes
        if i ~= k
            % Calculate the shortest path between i and k
            [~, d] = shortestpath(G_graph, i, k); % d is the shortest path distance
            l_ik = d; % Shortest path distance between i and k
            pi(i, k) = 0.5 - 0.5^l_ik; % Calculate π_ik
        end
    end
end

% Step 5: Generate vector b_k
b = zeros(n_nodes, n_nodes); % Initialize b_k vector
for k = 1:n_nodes
    for i = 1:n_nodes
        if i ~= k
            b(i, k) = pi(i, k) / (pi(i, k) + a * (1 - pi(i, k))); % Calculate b_ki
        end
    end
end

% Step 6: Generate vector x_k = (I + L)^-1 * b_k
I = eye(n_nodes); % Identity matrix
x = zeros(n_nodes, n_nodes); % Initialize x_k vector

for k = 1:n_nodes
    x(:, k) = (I + L) \ b(:, k); % Solve for x_k
end

% Step 7: Calculate Y_k = sum_k (1 - x_k)
Y = alpha * sum(1 - b, 1)'; % Y_k is the sum of (1 - x_k) for each k

% Step 8: Draw the graph and label each node with Y_k
figure;
h = plot(G_graph, 'NodeLabel', cellstr(num2str(Y, '%.2f'))); % Plot the graph with node labels as Y_k

% Find all nodes with the lowest Y_k
min_Y = min(Y);               % Find the minimum Y_k value
min_idx = find(abs(Y - min_Y) < 1e-6); % Include all nodes with the minimum Y_k

% Highlight all nodes with the lowest Y_k with a red dot
highlight(h, min_idx, 'NodeColor', [1 0 0]); % Highlight minimum Y_k nodes in red

% Set all other nodes to blue
h.NodeColor = repmat([0 0 1], n_nodes, 1); % Default all nodes to blue
highlight(h, min_idx, 'NodeColor', [1 0 0]); % Reapply red to minimum nodes

% Additional options for better visualization
title('Reputational Cost For Scapegoating - Decay Distance Effect');

% Step 9: Construct a graph where nodes are labeled with their degree
% Calculate custom labels using the formula
node_degrees = degree(G_graph); % Calculate the degree of each node
custom_labels = (n - node_degrees) .* (1 - 1 ./ (1 + a)) + node_degrees; % Apply the formula

% Find the nodes with the minimum value based on the custom labels
min_custom_label = min(custom_labels); % Minimum custom label
min_custom_idx = find(abs(custom_labels - min_custom_label) < 1e-6); % Indices of nodes with the minimum custom label

% Draw the graph and label nodes with their custom label
figure;
h2 = plot(G_graph, 'NodeLabel', cellstr(num2str(custom_labels, '%.2f'))); % Label nodes with custom labels

% Set all nodes to blue initially
h2.NodeColor = repmat([0 0 1], n_nodes, 1); % Default all nodes to blue

% Highlight nodes with the lowest custom label in red
highlight(h2, min_custom_idx, 'NodeColor', [1 0 0]); % Highlight nodes with the lowest custom label in red

% Additional visualization options
title('Reputational Cost For Scapegoating - Discrete Distance Effect');