# Dependency Direction

A lower layer must never name or link to the higher layers that depend on it — in docs, code, comments, examples, and rules alike. Use generic placeholders. Which components depend on a layer is knowledge that lives with those components, not with the layer.

This repo is a lower layer: shared config pulled by an unknown set of downstream consumers. [CLAUDE.md](../../../CLAUDE.md) applies the same principle to consumer enumeration; this rule generalizes it.
