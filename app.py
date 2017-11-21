import glob
import os
import random
import subprocess
import time
from flask import Flask, render_template, request, redirect, url_for, send_file

MATLAB = '/Applications/MATLAB_R2016b.app/bin/matlab -nodesktop -nosplash'

app = Flask(__name__)

@app.route('/')
def main():
    filters = [f[8:-2] for f in glob.glob('filters/*.m')]
    return render_template('index.html', filters=filters, os=os, cache=random.randint(0, 100000000))

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files['image']
    file.save('static/images/in')
    if os.path.exists('static/images/out.png'):
        os.remove('static/images/out.png')
    return redirect(url_for('main'))

def bash_command(cmd):
    subprocess.Popen(['/bin/bash', '-c', cmd])

@app.route('/source/<filter_name>')
def source(filter_name):
    return send_file('filters/{}.m'.format(filter_name), mimetype='text/text')

@app.route('/apply', methods=['GET', 'POST'])
def apply():
    if request.method == 'POST':
        filter_name = request.form['filter']
        if os.path.exists('static/images/out.png'):
            os.remove('static/images/out.png')
        bash_command('cat "filters/{}.m" | {}'.format(filter_name, MATLAB))
    if os.path.exists('static/images/out.png'):
        time.sleep(3)
        return redirect(url_for('main'))
    else:
        time.sleep(1)
        return redirect(url_for('apply'))

if __name__ == '__main__':
    app.run()
