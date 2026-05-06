import os
import zipfile
import sys

# 项目根目录
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_NAME = os.path.basename(PROJECT_DIR)
OUTPUT_DIR = os.path.join(os.path.dirname(PROJECT_DIR), "交付产物")
OUTPUT_ZIP = os.path.join(OUTPUT_DIR, f"{PROJECT_NAME}.zip")

# 需要排除的目录名
EXCLUDE_DIRS = {
    "node_modules",
    "venv",
    ".git",
    ".gitignore",
    ".playwright-mcp",
    ".agent",
    ".omc",
    ".windsurf",
    "docs",
    "target",
    "__pycache__",
    ".idea",
    ".vscode",
    ".gradle",
    "dist",
    "build",
    ".cache",
    ".tmp",
    "logs",
}

# 需要排除的文件名
EXCLUDE_FILES = {
    "项目轨迹.md",
    "轨迹.md",
    "CLAUDE.md",
    "result.md",
    "Rule.md",
    "nul",
    "pack.py",
    "package.py",
    ".gitignore",
    ".env",
    ".DS_Store",
    "Thumbs.db",
    "desktop.ini",
}

# 需要排除的文件扩展名
EXCLUDE_EXTENSIONS = {
    ".log",
    ".tmp",
    ".bak",
    ".swp",
    ".pyc",
    ".pyo",
    ".class",
    ".jar",
}


def should_exclude(root, name, is_dir):
    if is_dir:
        return name in EXCLUDE_DIRS
    if name in EXCLUDE_FILES:
        return True
    _, ext = os.path.splitext(name)
    if ext.lower() in EXCLUDE_EXTENSIONS:
        return True
    return False


def pack():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    file_count = 0
    with zipfile.ZipFile(OUTPUT_ZIP, "w", zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(PROJECT_DIR):
            # 原地修改 dirs 以跳过排除目录
            dirs[:] = [d for d in dirs if not should_exclude(root, d, True)]

            for f in files:
                if should_exclude(root, f, False):
                    continue
                full_path = os.path.join(root, f)
                arc_name = os.path.join(
                    PROJECT_NAME, os.path.relpath(full_path, PROJECT_DIR)
                )
                zf.write(full_path, arc_name)
                file_count += 1

    size_mb = os.path.getsize(OUTPUT_ZIP) / (1024 * 1024)
    print(f"打包完成: {OUTPUT_ZIP}")
    print(f"共 {file_count} 个文件, 大小 {size_mb:.2f} MB")


if __name__ == "__main__":
    pack()
