class String
	def is_integer?
		self =~ /\d+/
	end
end

class RangeDigits
	def set_inf(n)
		@inf = n
		@inf_str = @inf.to_s
		@inf_len = @inf_str.length
	end

	def set_sup(ten_pow, b)
		@sup_raw = @inf/ten_pow*ten_pow+ten_pow-1
		@sup = @sup_raw
		if ten_pow > 1
			while @sup > b
				@sup -= ten_pow/10
			end
		end
		@sup_str = @sup.to_s
	end

	def n_choose_k(n, k)
		if n-k < k
			numerator = k
		else
			numerator = n-k
		end
		denominator = 0
		choices = 1
		while numerator < n
			numerator += 1
			denominator += 1
			choices = choices*numerator/denominator
		end
		choices
	end

	def set_count(inf_chr, sup_chr, pow)
		count = 0
		if @c_chr >= inf_chr && @c_chr <= sup_chr
			if pow == @k-1
				count += 1
			elsif pow > @k-1
				vals = sup_chr.to_i-inf_chr.to_i+1
				if @k <= 0
					count += vals*(10**pow)
				else
					for i in @k..pow
						count += (vals-1)*(9**(pow-i))*n_choose_k(pow, i)
					end
					for i in @k-1..pow
						count += (9**(pow-i))*n_choose_k(pow, i)
					end
				end
			end
		else
			if pow >= @k
				vals = sup_chr.to_i-inf_chr.to_i+1
				if @k < 0
					count += vals*(10**pow)
				else
					for i in @k..pow
						count += vals*(9**(pow-i))*n_choose_k(pow, i)
					end
				end
			end
		end
		puts "inf #{@inf} sup #{@sup} count #{count}"
		STDOUT.flush
		@total += count
	end

	def initialize(a, b, c, k)
		a_str = a.to_s
		a_len = a_str.length
		b_str = b.to_s
		b_len = b_str.length
		@c_chr = c.to_s[0]
		@total = 0
		set_inf(a)
		head = a_len-1
		if head > 0
			@k = k-a_str[0..head-1].count(@c_chr)
		else
			@k = k
		end
		ten_pow = 10
		set_sup(ten_pow, b)
		while @inf_len == a_len && @sup_raw <= b
			set_count(@inf_str[head], @sup_str[head], a_len-head-1)
			set_inf(@sup+1)
			if head > 0
				head -= 1
				if a_str[head] == @c_chr
					@k += 1
				end
			end
			ten_pow *= 10
			set_sup(ten_pow, b)
		end
		while @inf_len < b_len
			set_count('1', '9', @inf_len-1)
			set_inf(@sup+1)
			ten_pow *= 10
			set_sup(ten_pow, b)
		end
		if @inf <= b
			ten_pow = 10**b_len
			head = 0
			@k = k
			while head < b_len-1 && @inf_str[head] == b_str[head]
				head += 1
				if b_str[head-1] == @c_chr
					@k -= 1
				end
				ten_pow /= 10
			end
			set_sup(ten_pow, b)
			while @inf <= b && head < b_len
				set_count(@inf_str[head], @sup_str[head], b_len-head-1)
				set_inf(@sup+1)
				head += 1
				if b_str[head-1] == @c_chr
					@k -= 1
				end
				if ten_pow > 1
					ten_pow /= 10
					set_sup(ten_pow, b)
				end
			end
		end
		puts "total #{@total}"
		STDOUT.flush
	end
end

if ARGV.size != 4 || !ARGV[0].is_integer? || ARGV[0].to_i < 1 || !ARGV[1].is_integer? || ARGV[1].to_i < ARGV[0].to_i || !ARGV[2].is_integer? || ARGV[2].to_i < 0 || ARGV[2].to_i > 9 || !ARGV[3].is_integer? || ARGV[3].to_i < 1
	STDERR.puts "Arguments: a >= 1, b >= a, 9 >= c >= 0, k >= 1"
	STDERR.flush
	exit false
end
RangeDigits.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_i)
