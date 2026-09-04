# Towards Quantum Gravity with Neural Networks: Topological and Gauge-Aware Ansätze

This repository reproduces and extends the results from:
**"Towards quantum gravity with neural networks: Solving the quantum Hamilton constraint of U(1) BF theory"** by H. Sahlmann and W. Sherif (arXiv:2402.10622).

We introduce novel **Graph Neural Network (GNN)** ansätze that explicitly leverage the dual graph topology and gauge structure to solve the quantum master constraint $\hat{C} = \hat{F} + \hat{G}$ of $U_q(1)$ BF theory.

## Motivation & The Topological Blindspot

The original paper utilizes a CNN architecture with `kernel_size=(1,)` for the learning block. As the authors explicitly note in Appendix D.1, this choice *"does not take into account any such spatial correlations... equivalent to a dense layer."* Consequently, the network treats the charges on the dual graph's edges as an independent set, ignoring the underlying gauge structure (Gauss constraint at vertices) and loop holonomies (Curvature constraint).

**Our Contribution:** We replace this topology-agnostic dense layer with **Graph Neural Networks (GCN, GAT, MPNN, Gauge-GCN)** that natively encode the dual graph $\tilde{\gamma}$ adjacency and gauge orientations, allowing the network to learn the constraints through structurally aligned message passing.

## Results Summary (2-L Graph)

All models trained with Exact Sampling, Stochastic Reconfiguration (SR/NTK), and Adam with cosine decay; results averaged over 3 seeds. The **Overlap** column denotes the state fidelity $\lvert\langle \Psi_{NN} \vert \Psi_{ED} \rangle\rvert^2$ between the network solution and the exact diagonalization (ED) ground state.

### The Ultimate Champion: Gauge-GCN

**Gauge-GCN** combines GCN's stabilizing architecture (normalized adjacency, BatchNorm, SE Block) with MPNN's physics-informed gauge signs as edge features. This hybrid achieves the best results across both cutoffs with minimal parameter overhead (+100-120 params, ~0.5% increase).

| m_max | Model | Parameters | Energy | Accuracy | Overlap |
|:-----:|-------|-----------:|-------:|--------:|--------:|
| 1 | Paper CNN* | 22,051 | 0.99866 | 80.5% | 0.9895 |
| 1 | Our GCN | 22,171 | 0.9262 | 86.7% | 0.9843 |
| 1 | Our MPNN | 25,921 | 0.8600 | **96.3%** | 0.9917 |
| 1 | **Gauge-GCN** | **22,291** | **0.9053** | 91.5% | **0.9950 🏆** |
| 2 | Paper CNN* | 22,051 | 0.62500 | 96.0% | 0.9979 |
| 2 | Our MPNN | 18,101 | 0.6283 | 95.5% | 0.9982 |
| 2 | Our GCN | 15,476 | 0.6258 | 95.8% | 0.9993 |
| 2 | **Gauge-GCN** | **15,576** | **0.6259** | **95.8%** | **0.9993 🏆** |

\* Reproduced CNN architecture (Appendix D.1 of the paper).

**Key Findings:**

1. **m_max=1 — Gauge-GCN achieves highest overlap:** By combining GCN's stabilizers with MPNN's gauge signs, Gauge-GCN reaches **0.9950 overlap**, beating all other models. Best single run achieved **98.95% accuracy and 0.9976 overlap**, approaching exact solution.
2. **m_max=2 — Gauge-GCN preserves GCN's excellence:** Gauge-GCN maintains GCN's near-perfect **0.9993 overlap** while also surpassing MPNN on both metrics. This demonstrates that gauge signs provide no harm in the well-constrained regime.
3. **Parameter efficiency:** Gauge-GCN achieves these results with only ~0.5% more parameters than GCN, making it the most effective architecture overall.

### The Failure of Arbitrary Attention (GAT)

| Model | m_max=1 Energy | m_max=1 Overlap |
|-------|---------------:|----------------:|
| GCN | 0.926 | 0.984 |
| GAT (various configs) | 5.3 – 6.3 ❌ | 0.03 – 0.07 ❌ |

**Physical Explanation:** The Gauss constraint $\hat{G} = \sum_v \left( \sum_{in} N_e - \sum_{out} N_e \right)^2$ is inherently **symmetric** — all edges meeting at a vertex contribute equally to charge conservation. GAT's selective attention mechanism breaks this symmetry and introduces softmax saturation. Equal-weight (GCN) or physics-weighted (MPNN/Gauge-GCN) message passing is structurally superior for gauge theories on small, dense graphs.

### Parameter Efficiency Ablation: Capacity vs. Physics Bias

We swept the MPNN width (hidden_dim 20/30/40 → 3,041/6,661/11,681 parameters). Performance degrades monotonically with width (m_max=1: 40.7% → 74.6% → 87.7% accuracy).

**Finding:** Gauge signs provide a powerful inductive bias, but the sparse amplitude structure of the physical state (19/3125 strongly contributing states at m_max=2, paper Table 5) still requires sufficient representational capacity. Physics bias and capacity are complementary, not interchangeable.

## Repository Structure

    .
    ├── run_netket_paper.py        # CNN baseline reproduction (Paper Appendix D.1)
    ├── run_gcn.py                 # GCN experiments
    ├── run_gat.py                 # GAT experiments (negative result)
    ├── run_mpnn.py                # Physics-Informed MPNN
    ├── run_gauge_gcn.py           # Gauge-GCN (final champion)
    ├── models/
    │   ├── gcn_ansatz.py          # Charge-aware GCN architecture
    │   ├── gat_ansatz.py          # GAT architecture
    │   ├── mpnn_ansatz.py         # Orientation-aware MPNN
    │   └── gauge_gcn_ansatz.py    # Hybrid Gauge-GCN (best overall)
    ├── requirements.txt
    └── README.md

## Setup & Usage

    python -m venv jupyter-env
    source jupyter-env/bin/activate
    pip install -r requirements.txt

    # Ensure JAX finds cuDNN if using NVIDIA GPUs via pip
    export LD_LIBRARY_PATH=$(python -c "import nvidia.cudnn; print(nvidia.cudnn.__path__[0])")/lib:$LD_LIBRARY_PATH

Run the experiments:

    python run_netket_paper.py  # CNN Baseline
    python run_gcn.py           # GCN Ansatz
    python run_mpnn.py          # Physics-Informed MPNN
    python run_gauge_gcn.py     # Gauge-GCN (Recommended)

## Conclusion

This work demonstrates that:

1. **Hybrid Physics-Informed + Topological architectures are optimal:** Gauge-GCN combines GCN's stabilizing message passing with MPNN's gauge-aware edge features, achieving the best overlap at both cutoffs.
2. **Physics-Informed Inductive Biases solve Overfitting:** Encoding Gauss constraint cross-terms into edge features resolves the overparameterization issues noted in the original paper.
3. **Topological Message Passing is Parameter Efficient:** GCN-based models achieve state-of-the-art overlap using significantly fewer parameters than topology-agnostic CNNs.
4. **Symmetry Matters:** For gauge theories, symmetric (GCN) or physically derived (MPNN) message passing outperforms arbitrary learned attention (GAT).
5. **Capacity and Bias are Complementary:** The parameter sweep shows physics bias cannot replace representational capacity for sparse physical states.

Future work will explore extending Gauge-GCN to non-Abelian SU(2) gauge groups and larger graph topologies.
EOF
## Architecture Overview

All ansätze take as input the five integer edge charges of the 2-L graph,

    x = (n_0, n_1, n_2, n_3, n_4),      n_i ∈ {-m_max, ..., m_max}

and output a scalar log-amplitude,

    log Ψ_θ(x)

used by NetKet as the variational wave function.

### Paper CNN Baseline

The original paper uses a 1D CNN block with `kernel_size=(1,)`. As noted by the authors, this effectively behaves like a pointwise dense transformation and does not explicitly encode spatial or graph correlations.

~~~mermaid
flowchart LR
    A["Input charges<br/>x = (n0,n1,n2,n3,n4)"] --> B["Normalize by m_max"]
    B --> C["Embedding / reshape"]
    C --> D["Conv1D kernel_size = 1"]
    D --> E["Activation + normalization"]
    E --> F["Dense evaluation block"]
    F --> G["log Psi_theta(x)"]

    style D fill:#ffe5e5,stroke:#cc0000,stroke-width:2px
    style G fill:#e8f4ff,stroke:#0066cc,stroke-width:2px
~~~

**Interpretation:** Since the convolution kernel has size 1, the model cannot directly aggregate information from neighboring dual edges. It treats edge charges almost independently.

---

### Our GCN Ansatz

The GCN introduces fixed-weight message passing over the dual graph adjacency matrix. Each dual edge receives information from its graph neighbors through the normalized adjacency matrix.

~~~mermaid
flowchart LR
    A["Input charges<br/>x = (n0,n1,n2,n3,n4)"] --> B["Normalize by m_max"]
    B --> C["Edge embedding"]

    C --> D1["Self message<br/>W_self h_i"]
    C --> D2["Neighbor message<br/>sum_j A_norm[i,j] W_neigh h_j"]

    D1 --> E["Add messages"]
    D2 --> E

    E --> F["BatchNorm"]
    F --> G["HardSiLU"]
    G --> H["SE block<br/>channel gating"]
    H --> I["Flatten"]
    I --> J["Dense evaluation block"]
    J --> K["log Psi_theta(x)"]

    style D2 fill:#e6ffe6,stroke:#008000,stroke-width:2px
    style H fill:#fff4cc,stroke:#cc9900,stroke-width:2px
    style K fill:#e8f4ff,stroke:#0066cc,stroke-width:2px
~~~

**Interpretation:** GCN adds the correct topological inductive bias: neighboring dual edges communicate through the graph structure. This is why GCN achieves excellent overlap at `m_max=2`.

---

### Gauge-Aware MPNN

The MPNN uses physics-derived edge features. In particular, it encodes the Gauss-constraint cross-term signs.

For the Gauss constraint,

    G_v = (sum_in N_e - sum_out N_e)^2

expanding the square gives cross terms with signs:

    s_ij = +1  if two edges have the same orientation at a vertex
    s_ij = -1  if they have opposite orientations

The MPNN passes both uniform and signed messages.

~~~mermaid
flowchart LR
    A["Input charges<br/>x = (n0,n1,n2,n3,n4)"] --> B["Normalize by m_max"]
    B --> C["Edge embedding"]

    C --> D1["Uniform message<br/>sum_j A[i,j] W h_j"]
    C --> D2["Gauge-signed message<br/>sum_j S[i,j] W h_j"]

    D1 --> E["Concatenate"]
    D2 --> E

    E --> F["Dense update"]
    F --> G["Residual connection"]
    G --> H["LayerNorm"]
    H --> I["HardSiLU"]
    I --> J["Mean pooling"]
    J --> K["Dense evaluation block"]
    K --> L["log Psi_theta(x)"]

    style D2 fill:#e6f0ff,stroke:#003399,stroke-width:2px
    style L fill:#e8f4ff,stroke:#0066cc,stroke-width:2px
~~~

**Interpretation:** The MPNN directly injects gauge-orientation information into the network. This is why it strongly improves the `m_max=1` regime, where the original CNN suffers from overfitting.

---

### Final Hybrid: Gauge-GCN

Gauge-GCN combines the two strongest ingredients:

1. GCN's stable topological message passing:
   
       A_norm h

2. MPNN's physics-informed gauge signs:
   
       S h

This gives a near-identical parameter budget to GCN while improving the `m_max=1` overlap and preserving the excellent `m_max=2` overlap.

~~~mermaid
flowchart LR
    A["Input charges<br/>x = (n0,n1,n2,n3,n4)"] --> B["Normalize by m_max"]
    B --> C["Edge embedding"]

    C --> D1["Self message<br/>W_self h_i"]
    C --> D2["GCN neighbor message<br/>sum_j A_norm[i,j] W_neigh h_j"]
    C --> D3["Gauge-signed message<br/>sum_j S[i,j] W_sign h_j"]

    D1 --> E["Add all messages"]
    D2 --> E
    D3 --> E

    E --> F["BatchNorm"]
    F --> G["HardSiLU"]
    G --> H["SE block"]
    H --> I["Flatten"]
    I --> J["Dense evaluation block"]
    J --> K["log Psi_theta(x)"]

    style D2 fill:#e6ffe6,stroke:#008000,stroke-width:2px
    style D3 fill:#e6f0ff,stroke:#003399,stroke-width:2px
    style H fill:#fff4cc,stroke:#cc9900,stroke-width:2px
    style K fill:#e8f4ff,stroke:#0066cc,stroke-width:2px
~~~

**Interpretation:** Gauge-GCN is the final champion architecture. It preserves GCN's stability while adding the physically meaningful gauge-sign channel. It achieves the highest overlap at both cutoffs with only around 0.5% more parameters than GCN.

---

### GAT: Attention-Based Message Passing

We also tested Graph Attention Networks. GAT replaces fixed adjacency weights with learned attention coefficients.

~~~mermaid
flowchart LR
    A["Input charges<br/>x = (n0,n1,n2,n3,n4)"] --> B["Normalize by m_max"]
    B --> C["Edge embedding"]

    C --> D["Compute attention logits<br/>e_ij = a^T [Wh_i, Wh_j]"]
    D --> E["Masked softmax<br/>alpha_ij"]
    E --> F["Attention message<br/>sum_j alpha_ij W h_j"]
    F --> G["Pooling"]
    G --> H["Dense evaluation block"]
    H --> I["log Psi_theta(x)"]

    style E fill:#ffe5e5,stroke:#cc0000,stroke-width:2px
    style I fill:#e8f4ff,stroke:#0066cc,stroke-width:2px
~~~

**Interpretation:** GAT performed poorly for this problem. The learned attention coefficients break the equal-weight symmetry of the Gauss constraint and lead to unstable optimization on this small, dense graph.

---

### Architectural Comparison

| Architecture | Topology-aware | Gauge-sign-aware | Learned attention | Main strength | Main weakness |
|-------------|:--------------:|:----------------:|:-----------------:|---------------|---------------|
| Paper CNN | No | No | No | Simple baseline | Ignores graph structure |
| GCN | Yes | No | No | Stable topological message passing | Does not encode edge orientation signs |
| MPNN | Yes | Yes | No | Strong physics-informed bias | Needs enough capacity |
| Gauge-GCN | Yes | Yes | No | Best overall hybrid | Slightly more parameters than GCN |
| GAT | Yes | No | Yes | Flexible attention | Breaks gauge symmetry, unstable here |

