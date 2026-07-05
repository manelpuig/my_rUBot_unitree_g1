from setuptools import find_packages, setup
import os
from glob import glob

package_name = 'my_g1_examples'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        (os.path.join('share', package_name, 'config'), glob('config/*.yaml')),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='manel',
    maintainer_email='manel.puig@ub.edu',
    description='Simple Unitree G1 motion examples for MuJoCo simulation',
    license='MIT',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'g1_pose_player = my_g1_examples.g1_pose_player:main',
        ],
    },
)