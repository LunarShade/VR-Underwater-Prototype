using UnityEngine;

public class Movement : MonoBehaviour
{
    [SerializeField]
    private Transform leftHandPos, rightHandPos;

    [SerializeField]
    private Transform headPos;

    [SerializeField]
    private SphereCollider headCollider;

    private Vector3 previousLeft;
    private Vector3 previousRight;
    private Vector3 velocity;

    private float speedMod = 0.15f;
    private float detectionThreshold = 0.001f;

    private void Awake()
    {
        previousLeft = leftHandPos.position;
        previousRight = rightHandPos.position;
    }

    private void Update()
    {
        CheckHandMovement();
        transform.position += velocity;
        if (headPos.position.y - headCollider.radius < 0)
        {
            transform.position = new Vector3(transform.position.x, transform.position.y - (headPos.position.y - headCollider.radius), transform.position.z);
        }

        velocity *= 0.98f;
    }

    private void CheckHandMovement()
    {
        Vector3 deltaLeft = leftHandPos.position - previousLeft;
        Vector3 deltaRight = rightHandPos.position - previousRight;

        if (deltaLeft.x < -detectionThreshold && deltaLeft.z < -detectionThreshold)
            velocity -= deltaLeft * speedMod;

        if (deltaRight.x > detectionThreshold && deltaRight.z < -detectionThreshold)
            velocity -= deltaRight * speedMod;

        previousLeft = leftHandPos.position;
        previousRight = rightHandPos.position;
    }
}
