/// This interface allows modification and retrieval of the contract balance.
#[starknet::interface]
pub trait IRewarder<TContractState> {
    /// Increase contract balance.
    fn add_points(ref self: TContractState, amount: u64);
    fn redeem_points(ref self: TContractState, amount: u64);

    /// Retrieve contract balance.
    fn get_balance(self: @TContractState) -> u64;
}

/// Simple contract for managing balance.
#[starknet::contract]
mod Rewarder {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        balance: u64,
    }

    #[event]
 #[derive(Drop, starknet::Event)]

    pub enum Event {
        points_added: PointsAdded,
        points_redeemed:PointsRedeemed
    }


 #[derive(Drop, starknet::Event)]
     pub struct PointsAdded {
        amount: u64,
    }


 #[derive(Drop, starknet::Event)]
 pub struct PointsRedeemed {
        amount: u64,
    }

    #[abi(embed_v0)]
    impl RewarderImpl of super::IRewarder<ContractState> {
        fn add_points(ref self: ContractState, amount: u64) {
            assert(amount != 0, 'Amount cannot be 0');
            self.balance.write(self.balance.read() + amount);
             self.emit(PointsAdded{amount});

        }

        fn redeem_points(ref self: ContractState, amount: u64) {
            assert(amount >= 0, 'Amount must be greater than 0');
            self.balance.write(self.balance.read() - amount);
            self.emit(PointsRedeemed{ amount});

        }

        fn get_balance(self: @ContractState) -> u64 {
            self.balance.read()
        }
    }
}
