#!/usr/bin/env python3
import json
import sys
from pathlib import Path


def usage():
    print("Usage: detect_phase_command.py <repo_root> <phase>", file=sys.stderr)


def read_package_scripts(repo_root):
    package_path = repo_root / "package.json"
    if not package_path.exists():
        return {}
    try:
        data = json.loads(package_path.read_text(encoding="utf-8"))
    except Exception:
        return {}
    scripts = data.get("scripts", {})
    return scripts if isinstance(scripts, dict) else {}


def package_runner(repo_root):
    if (repo_root / "pnpm-lock.yaml").exists():
        return "pnpm"
    if (repo_root / "yarn.lock").exists():
        return "yarn"
    if (repo_root / "bun.lockb").exists() or (repo_root / "bun.lock").exists():
        return "bun"
    return "npm"


def package_script_command(repo_root, script):
    runner = package_runner(repo_root)
    if runner == "npm":
        if script == "test":
            return "npm test"
        return f"npm run {script}"
    if runner == "yarn":
        return f"yarn {script}"
    if runner == "bun":
        return f"bun run {script}"
    return f"{runner} run {script}"


def first_existing_script(repo_root, names):
    scripts = read_package_scripts(repo_root)
    for name in names:
        if name in scripts:
            return package_script_command(repo_root, name)
    return ""


def existing_scripts(repo_root, names):
    scripts = read_package_scripts(repo_root)
    return [package_script_command(repo_root, name) for name in names if name in scripts]


def has_python_tests(repo_root):
    test_dirs = [repo_root / "tests", repo_root / "test"]
    if any(path.exists() for path in test_dirs):
        return True
    return any(repo_root.glob("**/test_*.py"))


def has_compose_file(repo_root):
    return any((repo_root / name).exists() for name in ("compose.yml", "compose.yaml", "docker-compose.yml", "docker-compose.yaml"))


def command_for(repo_root, phase):
    build = first_existing_script(repo_root, ("build", "compile"))
    proof_parts = existing_scripts(repo_root, ("lint", "typecheck", "check", "test", "test:unit", "test:integration"))
    deploy = first_existing_script(repo_root, ("deploy:dev", "dev:deploy", "deploy_dev", "deploy-dev"))
    verify = first_existing_script(repo_root, ("verify:dev", "dev:verify", "verify_dev", "smoke", "test:e2e", "e2e"))

    if phase == "build":
        if build:
            return build
        if (repo_root / "pyproject.toml").exists():
            return "python -m compileall ."
        return 'echo "No build command auto-detected; build is not required for this repository."'

    if phase == "proof":
        if proof_parts:
            return " && ".join(dict.fromkeys(proof_parts))
        if has_python_tests(repo_root):
            return "python -m pytest"
        return 'echo "No proof command auto-detected; add tests or set an explicit proof command when this repo has a retained gate."'

    if phase == "deploy_dev":
        if deploy:
            return deploy
        if has_compose_file(repo_root):
            return "docker compose up -d --build"
        return 'echo "No DEV deploy command auto-detected; DEV deployment is not required for this repository."'

    if phase == "verify_dev":
        if verify:
            return verify
        if deploy:
            return 'echo "No separate DEV verification command auto-detected; use proof plus manual runtime checks if this repo deploys DEV."'
        return 'echo "No DEV verification command auto-detected; DEV verification is not required for this repository."'

    raise SystemExit(f"Unsupported phase: {phase}")


def main():
    if len(sys.argv) != 3:
        usage()
        return 2
    repo_root = Path(sys.argv[1]).resolve()
    phase = sys.argv[2]
    if not repo_root.exists():
        print(f"Repository root not found: {repo_root}", file=sys.stderr)
        return 1
    print(command_for(repo_root, phase))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
