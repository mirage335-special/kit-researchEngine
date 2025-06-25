Here’s the safest way to lift just your updated `.github/workflows/build.yaml` into a clean PR without dragging all your other edits along:

1. **Ensure you have an upstream remote**
   Make sure your local clone has both your fork (`origin`) and the main ollama repo (`upstream`):

   ```bash
   git remote -v
   # if you don’t see “upstream”, add it:
   git remote add upstream https://github.com/ollama/ollama.git
   ```

2. **Fetch the latest `main`**

   ```bash
   git fetch upstream
   ```

3. **Create a new branch off of upstream’s `main`**

   ```bash
   git checkout upstream/main
   git checkout -b build-workflow-only
   ```

4. **Bring in just your changed workflow file**
   Assuming your feature branch is `mirage335/llama_3_1_nemotron_ultra_253b_v1`, do:

   ```bash
   git checkout mirage335/llama_3_1_nemotron_ultra_253b_v1 -- .github/workflows/build.yaml
   ```

   This copies *only* that one file (with your edits) into your new branch.

5. **Stage and commit**

   ```bash
   git add .github/workflows/build.yaml
   git commit -m "ci: add new build.yaml workflow"
   ```

6. **Push to your fork**

   ```bash
   git push origin build-workflow-only
   ```

7. **Open the Pull Request**

   1. Go to your fork on GitHub:
      `https://github.com/YOUR-USERNAME/ollama`
   2. You should see a banner “Compare & pull request” for `build-workflow-only`.
   3. Base repository: `ollama/ollama`, base branch: `main`
   4. Head repository: `YOUR-USERNAME/ollama`, compare branch: `build-workflow-only`
   5. Confirm that only `.github/workflows/build.yaml` is listed under “Files changed,” then submit.

---

### Alternative: cherry-pick (if your build.yaml changes live in a standalone commit)

If you already committed your workflow changes in a single commit on your feature branch, you can cherry-pick that commit instead of `git checkout --`. For example:

```bash
git checkout -b build-workflow-only upstream/main
git cherry-pick <SHA-of-build-yaml-commit>
git push origin build-workflow-only
# then open the PR as above
```

---

That’s it—by building the PR off of `main` and only importing the one file (or one commit), you ensure no other edits sneak into your pull request.
