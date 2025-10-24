class Burst;
    rand bit [3:0] burst_len;
    rand bit [31:0] addr;
    rand bit [3:0] write_en;
    rand bit read_en;

    constraint c_burst {
        burst_len inside {[2:8]};
        addr % 4 == 0;
        if(write_en) addr inside {[32'h1000_0000 : 32'h1000_FFFF]};
        if(read_en)  addr inside {[32'h0000_0000 : 32'h0000_FFFF]};

    }  
    constraint op_weights {
        read_en dist {1 :=80, 0 :=20};
        if(read_en) {
            write_en == 4'b0000;
        } else {
            write_en inside {4'b1111, 4'b1100, 4'b0011, 4'b1000, 4'b0100, 4'b0010, 4'b0001};
        }
    }

    function void burst_generator(ref bit [31:0] addr_seq [],
                                  ref bit [3:0]  write_en_seq [],
                                  ref bit read_en_seq[]);
        int i;
        addr_seq = new[burst_len];
        write_en_seq = new[burst_len];
        read_en_seq = new[burst_len];
        i = 0;
        repeat(burst_len) begin
            addr_seq[i] = addr + i*4;
            write_en_seq[i] = write_en;
            read_en_seq[i] = read_en;
            i++;
        end 
    endfunction
        
endclass 





module constraint_random_tb;
bit [31:0] addr_seq [];
bit [3:0] write_en_seq [];
bit read_en_seq [];



initial begin
    Burst b = new();
    b.randomize();
    b.burst_generator(addr_seq, write_en_seq, read_en_seq);

    for(int i = 0; i < b.burst_len; i++) begin
        $display("Cycle: %0d, addr: %h, write_en: %b, read_en: %b",
        i,
        addr_seq[i],
        write_en_seq[i],
        read_en_seq[i]);
        #10;
    end


end




endmodule
