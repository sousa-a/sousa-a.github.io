# sousa-a.github.io

Personal portfolio - Healthcare FWA Detection.

## Setup

```bash
# 1. Install Hugo extended
wget https://github.com/gohugoio/hugo/releases/download/v0.147.1/hugo_extended_0.147.1_linux-amd64.deb
sudo dpkg -i hugo_extended_0.147.1_linux-amd64.deb

# 2. Add PaperMod theme
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# 3. Add profile photo at static/img/profile.jpg (square, 320x320px+)

# 4. Local preview
hugo server -D

# 5. Deploy: push to main, GitHub Actions handles the rest
# Repo Settings > Pages > Source: GitHub Actions
```

## Structure

```
content/
  about/index.md
  cv/index.md
  projects/
    index.md
    fwa-auditing-system.md
```

