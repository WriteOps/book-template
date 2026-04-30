# Use the extra image which has more LaTeX packages pre-installed
FROM pandoc/extra:latest

# Install Node.js, NPM, Chromium, and Curl for remote assets
RUN apk add --no-cache nodejs npm chromium curl ca-certificates

# We might still need a few specific Eisvogel packages if they aren't in 'extra'
RUN tlmgr update --self || true
RUN tlmgr install footnotebackref pagecolor mdframed needspace ly1 zref \
    sourcecodepro sourcesanspro titling wrapfig capt-of || true
RUN texhash

# Set Puppeteer environment variables to use the installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set the working directory
WORKDIR /data

# Copy package.json and pnpm-lock.yaml (if exists)
COPY package.json ./

# Install npm dependencies (including mermaid-filter)
RUN npm install

# The build script expects mermaid-filter in node_modules/.bin/mermaid-filter
# We make sure it's in the PATH just in case
ENV PATH="/data/node_modules/.bin:${PATH}"

# Force Chromium to always run with --no-sandbox at the system level
# This fixes root issues for all Puppeteer-based tools
RUN mv /usr/bin/chromium-browser /usr/bin/chromium-browser-real && \
    echo '#!/bin/sh' > /usr/bin/chromium-browser && \
    echo 'exec /usr/bin/chromium-browser-real --no-sandbox "$@"' >> /usr/bin/chromium-browser && \
    chmod +x /usr/bin/chromium-browser

# Command to build the book
ENTRYPOINT ["./build.sh"]
