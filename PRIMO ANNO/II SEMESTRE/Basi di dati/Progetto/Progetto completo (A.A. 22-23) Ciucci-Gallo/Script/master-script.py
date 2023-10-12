import sys
import subprocess
import os

file_comment = """-- File di popolamento fittizio per test su FilmSphere
-- Creato da Ciucci Riccardo e Gallo Simone
"""
script_outputs = []
def execute_script(name, percentage=None):
    global script_outputs
    if not name:
        return ''
    script_name = name + '.py'
    out_name = name + '.sql'
    cmd = ['python', script_name]
    print ('Running \'' + script_name + '\' now...')
    if percentage:
        cmd.append(str(percentage))
    code = subprocess.Popen(cmd).wait()
    print('\t\'' + script_name + '\' finished with code ' + str(code) + '.')
    script_outputs.append(out_name)
    return out_name

def append_to_bundle(append_to, append_what):
    with open(append_to, 'a') as file_out, open(append_what, 'r') as file_in:
        for line in file_in:
            file_out.write(line)
        file_out.write('\n\n')

def bundle_files(names, out_name):
    print('Genereting bundle \'' + out_name + '\'...')
    
    with open(out_name, 'w') as file:
        file.write(file_comment + '\n')
        file.write('USE `FilmSphere`;\n\n')
        file.write('/*!SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0*/;\n')
        file.write('/*!SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0*/;\n')
        file.write('/*!SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE=\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION\'*/;\n\n')
    
    for name in names:
        print('\tAppending \'' + name + '\' to bundle...')
        append_to_bundle(out_name, name)
    
    print('\tAppending last lines...')
    with open(out_name, 'a') as file:
        file.write('\n/*!SET SQL_MODE=@OLD_SQL_MODE*/;\n')
        file.write('/*!SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS*/;\n')
        file.write('/*!SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS*/;')
    
    print('\nRemoving last temporary files...')
    for script_output in script_outputs:
        os.remove(script_output)
    print('\n\nBundle \'' + out_name + '\' is ready!')
    

if __name__ == '__main__':
    if len(sys.argv) < 2:
        file_names = [
            'inserimenti-casuali.sql',
            'generi.sql',
            'lingue-paesi.sql',
            'artisti-case-critici.sql',
            execute_script('film'),
            'generifilm-critiche.sql',
            'AreaFormato.sql',
            'abbonamenti.sql',
            execute_script('area-utenti'),
            execute_script('area-streaming'),
            execute_script('ip-ranges')
        ]
    else:
        percentage = float(sys.argv[1])
        file_names = [
            'inserimenti-casuali.sql',
            'generi.sql',
            'lingue-paesi.sql',
            'artisti-case-critici.sql',
            execute_script('film', percentage=percentage),
            'generifilm-critiche.sql',
            'AreaFormato.sql',
            'abbonamenti.sql',
            execute_script('area-utenti', percentage=percentage),
            execute_script('area-streaming'),
            execute_script('ip-ranges')
        ]
    out_name = 'FilmSphere.sql'
    bundle_files(names=file_names, out_name=out_name)