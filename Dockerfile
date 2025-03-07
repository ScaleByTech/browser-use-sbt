# Use Python 3.11 image
FROM python:3.11-slim-bullseye

# Install system dependencies (optional additions as needed)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /app

# Copy only the files needed to install dependencies first (better caching)
COPY pyproject.toml .
COPY README.md .
COPY setup.cfg .
COPY browser_use ./browser_use

# Install poetry/hatch/uv or whichever you use to manage your environment
# For demonstration, we’ll just install pip dependencies directly:
RUN pip install --upgrade pip
RUN pip install hatchling

# If your project has a proper pyproject.toml, you can install via:
#   pip install -e ".[dev]"
# Or if you have a standard requirements.txt, do:
#   pip install -r requirements.txt

# For Browser Use specifically:
RUN pip install -e ".[dev]"

# Copy the rest of the code (tests, examples, etc.)
COPY . .

# By default, we expect environment variables to be passed in by Elestio (via UI)
# e.g. OPENAI_API_KEY, ANTHROPIC_API_KEY, etc.

# Expose whatever port your app runs on (change to your needs)
EXPOSE 8000

# Default command to start the app with uvicorn
CMD ["uvicorn", "browser_use.main:app", "--host", "0.0.0.0", "--port", "8000"]
