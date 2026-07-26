# Docker Multi-Stage Builds

## 1. What is a Multi-Stage Build?

A multi-stage build uses multiple `FROM` instructions in a single Dockerfile.

The main purpose is to separate:

- Build/Preparation environment
- Runtime environment

General flow:

Stage 1:
Build or prepare the application.

Stage 2:
Copy only the required runtime files/artifacts from Stage 1 and run the application.

```text
Stage 1 (Builder)
      |
      | Build / Install Dependencies
      |
      v
Required Artifact
      |
      | COPY --from=builder
      v
Stage 2 (Runtime)
      |
      v
Final Application Image
