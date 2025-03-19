using UnityEngine;

public class FloatingObject : MonoBehaviour
{
    public float floatSpeed = 1f;     // 浮动速度
    public float floatHeight = 0.5f;  // 浮动高度

    private float startY;             // 初始Y坐标

    private void Start()
    {
        startY = transform.position.y; // 记录初始Y坐标
    }

    private void Update()
    {
        // 根据正弦函数计算Y轴偏移量
        float newY = startY + Mathf.Sin(Time.time * floatSpeed) * floatHeight;

        // 更新物体的位置
        transform.position = new Vector3(transform.position.x, newY, transform.position.z);
    }
}