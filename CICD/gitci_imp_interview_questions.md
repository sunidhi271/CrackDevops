1. What command to use to - unstage a staged file ?
```
git reset <file>
# OR
git restore --staged <file>
```
2. What command to use to - unstage all staged files ?
```
git reset
#OR
git restore --staged .
```
3. What command to use to - remove the changes done in unstaged file ?
```
git restore <file>
```
4. what command to use to - remove all unstaged changes ?
```
git restore .
```
5. What command to use to - remove all staged and unstaged changes ?
```
# Full reset to last commit
git reset --hard
```
6. What command to use to - uncommit last commit but keep the changes staged ?
```
git reset --soft HEAD~1
```
7. What command to use to - uncommit and discard changes done in that commit ?
```
git reset --hard HEAD~1
```
