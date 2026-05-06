import zipfile
import os

base_dir = r'e:\testProject\全栈项目\530\多重权限管理系统530'
zip_path = os.path.join(base_dir, 'label-530.zip')

exclude_dirs = {'node_modules', '.git', 'target', 'dist', '.idea', '__pycache__', '.gemini', 'logs'}

with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
    for root, dirs, files in os.walk(base_dir):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.log') or file.endswith('.zip'):
                continue
            file_path = os.path.join(root, file)
            arc_name = os.path.join('label-530', os.path.relpath(file_path, base_dir))
            zf.write(file_path, arc_name)
            
print(f'已创建: {zip_path}')
print(f'文件大小: {os.path.getsize(zip_path) / 1024 / 1024:.2f} MB')
