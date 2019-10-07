using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformMeshTransfer : TransferLifeForm
{


  public Form baseBuffer;

  public override void Bind(){

   transfer.BindForm("_BaseBuffer", baseBuffer);
   transfer.BindInt("_VertsPerMesh",() => baseBuffer.count);
  }
}
