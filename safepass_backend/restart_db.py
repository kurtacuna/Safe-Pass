import os
import subprocess
# from dotenv import load_dotenv

# dotenv_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env.development")
# load_dotenv(dotenv_path=dotenv_path)

def restart_db(project_path):
    if not os.path.isdir(project_path):
        print(f"Invalid project path: {project_path}")
        exit(1)

    # # For recreating postgres db
    # try:
    #     db_name = os.environ.get('DB_NAME')
    #     db_user = os.environ.get('DB_USER')
    #     db_host = os.environ.get('DB_HOST')
    #     db_port = os.environ.get('DB_PORT')
    #     db_password = os.environ.get('DB_PASSWORD')

    #     postgres_env = os.environ.copy()
    #     postgres_env['PGPASSWORD'] = db_password

    #     terminate_connections_command = f"""
    #         psql -h '{db_host}' -p '{db_port}' -U '{db_user}' -d '{db_name}' -c "
    #         SELECT pg_terminate_backend(pg_stat_activity.pid)
    #         FROM pg_stat_activity
    #         WHERE pg_stat_activity.datname = '{db_name}'
    #             AND pid <> pg_backend_pid();"
    #     """
    #     drop_db_command = f"psql -h '{db_host}' -p '{db_port}' -U '{db_user}' -d 'template1' -c 'DROP DATABASE IF EXISTS {db_name} WITH (FORCE);'"
    #     create_db_command = f"psql -h '{db_host}' -p '{db_port}' -U '{db_user}' -d 'template1' -c 'CREATE DATABASE {db_name}';"

    #     if os.name == 'posix': # For posix/linux/unix
    #         subprocess.run(["bash", "-c", terminate_connections_command], check=True, env=postgres_env)
    #         subprocess.run(["bash", "-c", drop_db_command], check=True, env=postgres_env)
    #         subprocess.run(["bash", "-c", create_db_command], check=True, env=postgres_env)
    #     elif os.name == 'nt': # For windows
    #         subprocess.run(["powershell", "-Command", terminate_connections_command], check=True, env=postgres_env)
    #         subprocess.run(["powershell", "-Command", drop_db_command], check=True, env=postgres_env)
    #         subprocess.run(["powershell", "-Command", create_db_command], check=True, env=postgres_env)
    # except subprocess.CalledProcessError as e:
    #     print(f"Error while restarting db: {e}")
    #     return


    for root, dirs, files in os.walk(project_path):
        if 'safepass_venv' in dirs:
            dirs.remove('safepass_venv')
        
        if 'db.sqlite3' in files:
            try: 
                db_path = os.path.join(root, 'db.sqlite3')
                os.remove(db_path)
                print(f"Removed: {db_path}")
                # print(db_path)
            except Exception as e:
                print(f"Error: {e}")
                exit(1)

        if 'migrations' in dirs:
            migrations_path = os.path.join(root, 'migrations')
            for filename in os.listdir(migrations_path):
                if filename.endswith('.py') and filename != '__init__.py':
                    file_path = os.path.join(migrations_path, filename)
                    try:
                        os.remove(file_path)
                        # print(file_path)
                        print(f"Removed: {file_path}")
                    except Exception as e:
                        print(f"Error: {e}")
                        exit(1)
    
    try:
        bash_command = (
            "python manage.py makemigrations && "
            "python manage.py migrate && "
            "django-admin loaddata pre_load_db"
        )

        powershell_command = (
            "python manage.py makemigrations; "
            "python manage.py migrate; "
            "django-admin loaddata pre_load_db"
        )

        if os.name == 'posix': # For posix/linux/unix
            subprocess.run(["bash", "-c", bash_command], check=True)
        elif os.name == 'nt': # For windows
            subprocess.run(["powershell", "-Command", powershell_command], check=True)

        print("Database Restarted")
    except subprocess.CalledProcessError as e:
        print(f"Error while restarting db: {e}")




if __name__ == "__main__":
    script_file_path = os.path.dirname(os.path.abspath(__file__))
    restart_db(script_file_path)