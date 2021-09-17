using UnityEngine;

public class MoveTerrain : MonoBehaviour
{
    [SerializeField]
    private MeshRenderer meshRenderer;

    [SerializeField]
    private Transform player;

    private Vector2 mainTextureScale;
    private Vector2 normalScale;
    private Vector2 foamScale;

    public float testVal;

    private void Awake()
    {
        mainTextureScale = meshRenderer.material.GetTextureScale("_MainTex") / 100;
        normalScale = meshRenderer.material.GetTextureScale("_Normal") / 100;
        foamScale = meshRenderer.material.GetTextureScale("_WaterFoam") / 100;
    }

    private void Update()
    {
        UpdateMeshPosition();
    }

    private void UpdateMeshPosition()
    {
        transform.position = new Vector3(player.position.x, 0, player.position.z);
        meshRenderer.material.SetTextureOffset("_MainTex", new Vector2(-transform.position.x * mainTextureScale.x, -transform.position.z * mainTextureScale.y));
        meshRenderer.material.SetTextureOffset("_Normal", new Vector2(-transform.position.x * normalScale.x, -transform.position.z * normalScale.y));
        meshRenderer.material.SetTextureOffset("_WaterFoam", new Vector2(-transform.position.x * foamScale.x, -transform.position.z * foamScale.y));
    }
}
