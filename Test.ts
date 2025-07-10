import { ethers } from "hardhat";
import { expect } from "chai";

describe("IdentityVerifier", function () {
  let verifier: any;
  let owner: any;
  let user: any;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();

    const Verifier = await ethers.getContractFactory("IdentityVerifier");
    verifier = await Verifier.deploy();
    await verifier.deployed();
  });

  it("should start with user unverified", async () => {
    const status = await verifier.isUserVerified(user.address);
    expect(status).to.equal(false);
  });

  it("should verify a user", async () => {
    const fakeProof = "0x1234"; // Placeholder for zk proof
    await verifier.verify(user.address, fakeProof);
    
    const status = await verifier.isUserVerified(user.address);
    expect(status).to.equal(true);
  });

  it("should allow owner to revoke verification", async () => {
    const fakeProof = "0x1234";
    await verifier.verify(user.address, fakeProof);

    await verifier.revoke(user.address);

    const status = await verifier.isUserVerified(user.address);
    expect(status).to.equal(false);
  });

  it("should not allow non-owner to verify", async () => {
    const fakeProof = "0x1234";
    await expect(
      verifier.connect(user).verify(user.address, fakeProof)
    ).to.be.revertedWith("Not contract owner");
  });
});
