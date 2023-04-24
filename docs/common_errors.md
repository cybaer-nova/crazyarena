# Common errors

If you encouter the issue *ModuleNotFoundError: No module named 'crazyswarm'* while running a real experiment using the crazyswarm package, add these lines in the begining of the *crazyflie.py* file.

```python
# /home/crazyuser/crazyswarm/ros_ws/src/crazyswarm/scripts/pycrazyswarm/crazyflie.py

from os.path import dirname, abspath
sys.path.insert(0, dirname(dirname(dirname(abspath(__file__)))))
```
